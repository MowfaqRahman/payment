import streamlit as st
import pandas as pd
from sqlalchemy import create_engine, Column, Integer, String, Float, Date, ForeignKey, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
import datetime
import os

# --- PAGE CONFIG ---
st.set_page_config(
    page_title="LoanPay Dashboard",
    page_icon="💰",
    layout="wide",
    initial_sidebar_state="expanded",
)

# --- DATABASE SETUP ---
DB_PATH = "backend/sql_app.db"
if not os.path.exists(DB_PATH):
    # Try alternate path for local dev if run from backend folder
    DB_PATH = "sql_app.db"

SQLALCHEMY_DATABASE_URL = f"sqlite:///./{DB_PATH}"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Models (Duplicate here for self-contained streamlit app)
class Customer(Base):
    __tablename__ = "customers"
    id = Column(Integer, primary_key=True, index=True)
    account_number = Column(String, unique=True, index=True)
    issue_date = Column(Date)
    interest_rate = Column(Float)
    tenure = Column(Integer)
    emi_due = Column(Float)
    payments = relationship("Payment", back_populates="customer")

class Payment(Base):
    __tablename__ = "payments"
    id = Column(Integer, primary_key=True, index=True)
    customer_id = Column(Integer, ForeignKey("customers.id"))
    payment_date = Column(DateTime, default=datetime.datetime.utcnow)
    amount = Column(Float)
    status = Column(String, default="Success")
    customer = relationship("Customer", back_populates="payments")

# Create tables if they don't exist
Base.metadata.create_all(bind=engine)

# --- CUSTOM CSS ---
st.markdown("""
    <style>
    .main {
        background-color: #f8f9fa;
    }
    .stButton>button {
        width: 100%;
        border-radius: 5px;
        height: 3em;
        background-color: #007bff;
        color: white;
    }
    .stMetric {
        background-color: #ffffff;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    h1 {
        color: #1e3d59;
        font-weight: 700;
    }
    .sidebar .sidebar-content {
        background-image: linear-gradient(#2e7bcf,#2e7bcf);
        color: white;
    }
    </style>
    """, unsafe_allow_html=True)

# --- APP LOGIC ---
def get_db():
    db = SessionLocal()
    try:
        return db
    finally:
        db.close()

def main():
    st.title("💰 LoanPay Management")
    st.markdown("### Premium Payment Collection Dashboard")
    
    db = get_db()
    
    # Sidebar
    st.sidebar.image("https://cdn-icons-png.flaticon.com/512/2845/2845914.png", width=100)
    st.sidebar.title("Navigation")
    page = st.sidebar.radio("Go to", ["Dashboard", "Customers", "New Payment", "History"])
    
    if page == "Dashboard":
        show_dashboard(db)
    elif page == "Customers":
        show_customers(db)
    elif page == "New Payment":
        show_make_payment(db)
    elif page == "History":
        show_history(db)

def show_dashboard(db):
    st.subheader("Market Overview")
    
    # Metrics
    c1, c2, c3, c4 = st.columns(4)
    customers = db.query(Customer).all()
    payments = db.query(Payment).all()
    
    total_customers = len(customers)
    total_collected = sum(p.amount for p in payments)
    pending_emi = sum(c.emi_due for c in customers)
    avg_interest = sum(c.interest_rate for c in customers) / total_customers if total_customers > 0 else 0
    
    c1.metric("Total Customers", total_customers)
    c2.metric("Total Collected", f"${total_collected:,.2f}")
    c3.metric("Pending EMI", f"${pending_emi:,.2f}")
    c4.metric("Avg Interest", f"{avg_interest:.1f}%")
    
    st.markdown("---")
    
    # Recent Payments Table
    st.write("#### Recent Transactions")
    if payments:
        df_p = pd.DataFrame([{
            "Date": p.payment_date.strftime("%Y-%m-%d %H:%M"),
            "Account": p.customer.account_number,
            "Amount": f"${p.amount:,.2f}",
            "Status": p.status
        } for p in payments[-10:]])
        st.table(df_p.iloc[::-1])
    else:
        st.info("No transactions yet.")

def show_customers(db):
    st.subheader("Customer Directory")
    customers = db.query(Customer).all()
    if customers:
        df_c = pd.DataFrame([{
            "Account Number": c.account_number,
            "Issue Date": c.issue_date,
            "Interest Rate": f"{c.interest_rate}%",
            "Tenure (mos)": c.tenure,
            "EMI Due": f"${c.emi_due:,.2f}"
        } for c in customers])
        st.dataframe(df_c, use_container_width=True)
    else:
        st.warning("No customers found in database.")
        if st.button("Seed Sample Data"):
            from datetime import date
            sample_customers = [
                Customer(account_number="ACC1001", issue_date=date(2023, 1, 15), interest_rate=12.5, tenure=24, emi_due=1500.0),
                Customer(account_number="ACC1002", issue_date=date(2023, 3, 10), interest_rate=10.0, tenure=36, emi_due=2200.5),
                Customer(account_number="ACC1003", issue_date=date(2023, 6, 20), interest_rate=11.2, tenure=12, emi_due=5000.0)
            ]
            db.add_all(sample_customers)
            db.commit()
            st.success("Data seeded! Refreshing...")
            st.rerun()

def show_make_payment(db):
    st.subheader("Record New Payment")
    customers = db.query(Customer).all()
    if not customers:
        st.error("No customers available. Please add customers first.")
        return
        
    acc_list = [c.account_number for c in customers]
    
    with st.form("payment_form"):
        selected_acc = st.selectbox("Select Customer Account", acc_list)
        amount = st.number_input("Payment Amount ($)", min_value=0.0, step=100.0)
        submit = st.form_submit_button("Submit Payment")
        
        if submit:
            customer = db.query(Customer).filter(Customer.account_number == selected_acc).first()
            new_payment = Payment(customer_id=customer.id, amount=amount)
            db.add(new_payment)
            db.commit()
            st.success(f"Payment of ${amount:,.2f} recorded for {selected_acc}!")

def show_history(db):
    st.subheader("Payment History Search")
    acc_number = st.text_input("Enter Account Number", "")
    
    if acc_number:
        customer = db.query(Customer).filter(Customer.account_number == acc_number).first()
        if customer:
            st.write(f"Showing history for **{acc_number}**")
            p_history = customer.payments
            if p_history:
                df_h = pd.DataFrame([{
                    "Date": p.payment_date.strftime("%Y-%m-%d %H:%M"),
                    "Amount": f"${p.amount:,.2f}",
                    "Status": p.status
                } for p in p_history])
                st.dataframe(df_h, use_container_width=True)
            else:
                st.info("No payment history for this account.")
        else:
            st.error("Account not found.")

if __name__ == "__main__":
    main()
