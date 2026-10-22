import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from datetime import datetime

wb = openpyxl.Workbook()

# Setup sheets
ws_summary = wb.active
ws_summary.title = "Executive Summary"
ws_details = wb.create_sheet(title="Panel-Wise Deliverables")

# Fonts & Colors
font_title = Font(name="Calibri", size=18, bold=True, color="0F172A")
font_subtitle = Font(name="Calibri", size=11, italic=True, color="64748B")
font_section = Font(name="Calibri", size=13, bold=True, color="0F172A")
font_header = Font(name="Calibri", size=11, bold=True, color="FFFFFF")
font_bold = Font(name="Calibri", size=11, bold=True)
font_regular = Font(name="Calibri", size=11)
font_kpi_num = Font(name="Calibri", size=22, bold=True)
font_kpi_lbl = Font(name="Calibri", size=10, bold=True, color="64748B")

fill_header = PatternFill(start_color="0F172A", end_color="0F172A", fill_type="solid")
fill_completed = PatternFill(start_color="DCFCE7", end_color="DCFCE7", fill_type="solid")
fill_in_progress = PatternFill(start_color="FEF3C7", end_color="FEF3C7", fill_type="solid")
fill_pending = PatternFill(start_color="F1F5F9", end_color="F1F5F9", fill_type="solid")
fill_zebra = PatternFill(start_color="F8FAFC", end_color="F8FAFC", fill_type="solid")
fill_white = PatternFill(start_color="FFFFFF", end_color="FFFFFF", fill_type="solid")

font_completed = Font(name="Calibri", size=11, bold=True, color="15803D")
font_in_progress = Font(name="Calibri", size=11, bold=True, color="B45309")
font_pending = Font(name="Calibri", size=11, bold=True, color="475569")

font_prio_high = Font(name="Calibri", size=11, bold=True, color="B91C1C")
font_prio_med = Font(name="Calibri", size=11, bold=True, color="D97706")
font_prio_low = Font(name="Calibri", size=11, bold=True, color="475569")

thin_border_side = Side(style='thin', color="E2E8F0")
border_all = Border(left=thin_border_side, right=thin_border_side, top=thin_border_side, bottom=thin_border_side)

# ─────────────────────────────────────────────────────────────────────────────
# 38 PANEL-WISE DELIVERABLES
# ─────────────────────────────────────────────────────────────────────────────
tasks = [
    # Panel 1: Super Admin Portal (Web)
    (1, "Panel 1: Admin Portal (Web)", "Live Orders Engine", 
     "Connects to live MongoDB with 27 real orders; click-to-filter tabs (All, Pending, Active, Completed); partner/rider allocation modal.", 
     "Completed", "100%", "High", "Full lifecycle active on MongoDB cluster."),
    (2, "Panel 1: Admin Portal (Web)", "Real-Time Order Radar Tracker", 
     "Interactive live visual tracker following orders across status transitions (Created -> Assigned -> In Transit -> Completed).", 
     "Completed", "100%", "High", "Operational across all browser sessions."),
    (3, "Panel 1: Admin Portal (Web)", "Executive Overview & Live KPIs", 
     "Live revenue aggregate, order counters, week-over-week trends, dynamic 7-day revenue chart, category distribution.", 
     "Completed", "100%", "High", "All fake percentages removed; real trends active."),
    (4, "Panel 1: Admin Portal (Web)", "Partner Store Management", 
     "Onboarding, KYC document audit (Aadhaar, PAN, GST, Shop License), approval workflow (Active / Suspended / Pending).", 
     "Completed", "100%", "High", "Integrated directly with /api/partners."),
    (5, "Panel 1: Admin Portal (Web)", "Delivery Agent / Rider Fleet", 
     "Rider onboarding, vehicle verification (RC, DL, Insurance), live online status, Admin Fleet vs Partner Fleet filtering.", 
     "Completed", "100%", "High", "Integrated directly with /api/delivery-agents."),
    (6, "Panel 1: Admin Portal (Web)", "Customer Directory", 
     "Dynamic customer aggregation from live orders; total spend, order count, contact details, status toggle (Active/Blocked).", 
     "Completed", "100%", "Medium", "Dynamic customer aggregation working seamlessly."),
    (7, "Panel 1: Admin Portal (Web)", "Reports & Analytics Hub", 
     "Dynamic date range filters (7d, 30d, 90d, Year), Partner performance table, Rider metrics, monthly revenue trends.", 
     "Completed", "100%", "High", "Live charts rendering from database orders."),
    (8, "Panel 1: Admin Portal (Web)", "Camera Rental Management", 
     "Cinema & mirrorless rental catalog, daily rates, inventory stock counts, live rental bookings linked to database.", 
     "Completed", "100%", "High", "Rental catalog & orders sync operational."),
    (9, "Panel 1: Admin Portal (Web)", "Refurbished Store Catalog", 
     "Listing management, 3-tier condition grading (Superb, Good, Fair), stock status, warranty tag configuration.", 
     "Completed", "100%", "Medium", "Catalog management fully operational."),
    (10, "Panel 1: Admin Portal (Web)", "Pricing & Valuation Matrix", 
     "Valuation quiz questions, dynamic price adjustments (+/-), condition penalty matrix, camera lens pricing rules.", 
     "Completed", "100%", "High", "Connected to live /api/questions & /api/lenses."),
    (11, "Panel 1: Admin Portal (Web)", "Audio-Visual Alerts Hub", 
     "Web Audio chimes, native OS push notifications, unread badges, cross-tab BroadcastChannel sync.", 
     "Completed", "100%", "Medium", "Real-time alert dispatch active."),
    (12, "Panel 1: Admin Portal (Web)", "Content Management (CMS)", 
     "Homepage hero banners, trust metrics, customer testimonials, FAQs, and footer settings editable from dashboard.", 
     "Completed", "100%", "Medium", "Allows admin to update web content without code change."),
    (13, "Panel 1: Admin Portal (Web)", "Coupon & Promo Engine", 
     "Fixed/percentage discount coupon creator, validity dates, minimum order limits, usage cap counters.", 
     "Completed", "100%", "Low", "Backend models and admin interface ready."),
    (14, "Panel 1: Admin Portal (Web)", "Support Ticketing System", 
     "Multi-role ticketing (User, Partner, Rider), category routing, priority flags, resolution threads.", 
     "Completed", "100%", "Medium", "Multi-role panel active."),

    # Panel 2: Partner Store Portal (Web)
    (15, "Panel 2: Partner Portal (Web)", "Partner Auth & Middleware", 
     "Store login with credentials, approval verification, session storage, protected route middleware.", 
     "Completed", "100%", "High", "Pending approval lock & active login functional."),
    (16, "Panel 2: Partner Portal (Web)", "Partner Dashboard & KPIs", 
     "Store welcome header, live earnings, order counters, dynamic 7-day revenue graph, runtime crash fixes.", 
     "Completed", "100%", "High", "Bug fixed and dynamic values rendering cleanly."),
    (17, "Panel 2: Partner Portal (Web)", "12-Point Inspection Tool", 
     "Physical & technical diagnostic checklist, automated deduction calculation, spot payout locking.", 
     "Completed", "100%", "High", "Complete valuation locking workflow active."),
    (18, "Panel 2: Partner Portal (Web)", "Order Acceptance Queue", 
     "Incoming orders queue, accept/reject, pickup scheduling, customer contact, and delivery handoff.", 
     "Completed", "100%", "High", "Operational."),
    (19, "Panel 2: Partner Portal (Web)", "Dedicated Store Fleet", 
     "Partner-specific rider listing, onboarding riders for store fleet, direct order assignment.", 
     "Completed", "100%", "Medium", "Integrated with delivery agent API."),
    (20, "Panel 2: Partner Portal (Web)", "Partner Payouts & Ledger", 
     "Available balance, withdrawal request workflow, transaction ledger, and payment gateway fund addition.", 
     "In Progress", "85%", "High", "UI & calculation completed; banking disbursement verification ongoing."),
    (21, "Panel 2: Partner Portal (Web)", "Store Customer Directory", 
     "Directory of customers who transacted with the partner store, order frequency, and lifetime value.", 
     "Completed", "100%", "Medium", "Customer history active."),

    # Panel 3: Customer Web Portal & Storefront
    (22, "Panel 3: Customer Portal (Web)", "Sell Device & Valuation Wizard", 
     "Instant price calculation wizard, condition questionnaire, accessories selection, quote generation (/sell-device-get-quote).", 
     "Completed", "100%", "High", "Core valuation engine active."),
    (23, "Panel 3: Customer Portal (Web)", "Camera Rental Booking", 
     "Cinema & mirrorless camera catalog, date range picker, security deposit calculation, doorstep delivery booking (/rental-cameras).", 
     "Completed", "100%", "High", "Live bookings sync with order database."),
    (24, "Panel 3: Customer Portal (Web)", "Buy Refurbished Store", 
     "E-commerce listing of certified refurbished devices, condition filters, transparent pricing, checkout (/buy-refurbished).", 
     "Completed", "100%", "High", "Refurbished storefront operational."),
    (25, "Panel 3: Customer Portal (Web)", "Device Repair Booking", 
     "Service selection for cameras and phones (Screen, Lens, Sensor, Battery), repair cost estimator (/repair-device).", 
     "Completed", "100%", "Medium", "Repair booking workflow active."),
    (26, "Panel 3: Customer Portal (Web)", "Live Order Tracking", 
     "Customer self-service order tracking with order number and phone number verification (/track-order).", 
     "Completed", "100%", "High", "Customer tracker operational."),
    (27, "Panel 3: Customer Portal (Web)", "Customer Account & Orders", 
     "User profile, past sell/rental/repair order history, invoice download, payment status (/my-orders, /user).", 
     "Completed", "90%", "Medium", "Profile and orders view active."),
    (28, "Panel 3: Customer Portal (Web)", "Device Verification & IMEI", 
     "Instant IMEI & serial number blacklist / verification check before sale confirmation (/verify-device).", 
     "Completed", "90%", "High", "Verification check functional."),

    # Panel 4: Delivery Agent / Rider Operations
    (29, "Panel 4: Rider Operations (Web)", "Rider Web Dispatch Portal", 
     "Rider login, task list of assigned doorstep pickups, customer addresses, pickup time slots (/delivery).", 
     "Completed", "100%", "High", "Web dispatch panel active."),
    (30, "Panel 4: Rider Operations (Web)", "Doorstep Pickup Verification", 
     "Rider device checklist on arrival, customer identity verification, photo upload of device condition.", 
     "In Progress", "85%", "High", "Checklist UI complete; final photo upload testing."),
    (31, "Panel 4: Rider Operations (Web)", "Rider Daily Earnings Ledger", 
     "Per-pickup commission tracking, completed trips summary, daily settlement status.", 
     "In Progress", "80%", "Medium", "Commission calculations in progress."),

    # Panel 5: Backend APIs & Database
    (32, "Panel 5: Backend & APIs", "MongoDB Atlas Live Cluster", 
     "Production cluster connection holding live orders (27 active records), partners, riders, questions, and lenses.", 
     "Completed", "100%", "High", "Active in production on port 4028."),
    (33, "Panel 5: Backend & APIs", "Core REST Endpoints", 
     "CRUD APIs: /api/orders, /api/partners, /api/delivery-agents, /api/questions, /api/lenses with schema validation.", 
     "Completed", "100%", "High", "Tested and serving web/app clients."),
    (34, "Panel 5: Backend & APIs", "Supabase Realtime Sync", 
     "Live channel synchronization for instant order updates across admin and partner browser tabs.", 
     "Completed", "90%", "High", "Integrated in orders tracker."),
    (35, "Panel 5: Backend & APIs", "Automated Payout Gateway", 
     "RazorpayX / Cashfree integration for automated instant UPI/NEFT payouts upon completed inspection.", 
     "In Progress", "70%", "High", "Sandbox testing active; live merchant credentials needed."),
    (36, "Panel 5: Backend & APIs", "SMS & WhatsApp OTP Gateway", 
     "Twilio / MSG91 integration for customer login OTP, booking notifications, and pickup OTP verification.", 
     "In Progress", "60%", "High", "DLT templates & sender ID approval in progress."),

    # Panel 6: Flutter Mobile Applications & Deployment
    (37, "Panel 6: Mobile Apps (Flutter)", "Flutter Apps Suite (4 Apps)", 
     "Partner App (camsik-partner - 80%), Rider App (camsik-delivery - 75%), Customer App (camsik-user - 70%), Admin App (camsik-admin - 65%).", 
     "In Progress", "75%", "High", "Core workflows built; API integration testing."),
    (38, "Panel 6: Mobile Apps (Flutter)", "Play Store & App Store Release", 
     "Production AAB / IPA build generation, store listing assets, Google Play Console & Apple Developer submission.", 
     "Pending", "20%", "High", "Store screenshots ready; waiting on client developer accounts.")
]

# ─────────────────────────────────────────────────────────────────────────────
# WRITE DETAILS SHEET
# ─────────────────────────────────────────────────────────────────────────────
headers = ["S.No", "Panel / System", "Feature / Deliverable", "Scope & Functionality in Casmik", "Status", "Progress", "Priority", "Deliverable / Technical Remarks"]
ws_details.append(headers)

for col_num, h in enumerate(headers, 1):
    cell = ws_details.cell(row=1, column=col_num)
    cell.font = font_header
    cell.fill = fill_header
    cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
ws_details.row_dimensions[1].height = 28

for row_idx, task in enumerate(tasks, start=2):
    s_no, module, feature, scope, status, progress, priority, remarks = task
    ws_details.append([s_no, module, feature, scope, status, progress, priority, remarks])
    
    ws_details.row_dimensions[row_idx].height = 24
    row_fill = fill_zebra if row_idx % 2 == 0 else fill_white

    for col_idx in range(1, 9):
        c = ws_details.cell(row=row_idx, column=col_idx)
        c.border = border_all
        c.fill = row_fill
        c.font = font_regular
        c.alignment = Alignment(vertical="center")

        if col_idx == 1:
            c.alignment = Alignment(horizontal="center", vertical="center")
        elif col_idx == 5: # Status
            c.alignment = Alignment(horizontal="center", vertical="center")
            if status == "Completed":
                c.fill = fill_completed
                c.font = font_completed
            elif status == "In Progress":
                c.fill = fill_in_progress
                c.font = font_in_progress
            else:
                c.fill = fill_pending
                c.font = font_pending
        elif col_idx == 6: # Progress
            c.alignment = Alignment(horizontal="center", vertical="center")
            c.font = font_bold
        elif col_idx == 7: # Priority
            c.alignment = Alignment(horizontal="center", vertical="center")
            if priority == "High":
                c.font = font_prio_high
            elif priority == "Medium":
                c.font = font_prio_med
            else:
                c.font = font_prio_low

col_widths = {
    1: 8,   # S.No
    2: 30,  # Panel / System
    3: 36,  # Feature
    4: 65,  # Scope
    5: 16,  # Status
    6: 12,  # Progress
    7: 12,  # Priority
    8: 45   # Remarks
}
for col_idx, width in col_widths.items():
    col_letter = get_column_letter(col_idx)
    ws_details.column_dimensions[col_letter].width = width

for row in ws_details.iter_rows(min_row=2, max_col=8):
    row[2].alignment = Alignment(vertical="center", wrap_text=True)
    row[3].alignment = Alignment(vertical="center", wrap_text=True)
    row[7].alignment = Alignment(vertical="center", wrap_text=True)

# ─────────────────────────────────────────────────────────────────────────────
# WRITE SUMMARY SHEET
# ─────────────────────────────────────────────────────────────────────────────
total_tasks = len(tasks)
completed_tasks = sum(1 for t in tasks if t[4] == "Completed")
in_progress_tasks = sum(1 for t in tasks if t[4] == "In Progress")
pending_tasks = sum(1 for t in tasks if t[4] == "Pending")

comp_pct = round((completed_tasks / total_tasks) * 100)
prog_pct = round((in_progress_tasks / total_tasks) * 100)
pend_pct = round((pending_tasks / total_tasks) * 100)

ws_summary.column_dimensions['A'].width = 4
ws_summary.column_dimensions['B'].width = 28
ws_summary.column_dimensions['C'].width = 20
ws_summary.column_dimensions['D'].width = 20
ws_summary.column_dimensions['E'].width = 20
ws_summary.column_dimensions['F'].width = 20

ws_summary.cell(row=2, column=2, value="CAMSIK ECOSYSTEM — PANEL-WISE PROJECT REPORT").font = font_title
ws_summary.cell(row=3, column=2, value=f"Generated on: {datetime.now().strftime('%d %B %Y')} | Codebase Reference: casmik").font = font_subtitle

# KPI Cards
ws_summary.cell(row=5, column=2, value="TOTAL DELIVERABLES").font = font_kpi_lbl
ws_summary.cell(row=6, column=2, value=f"{total_tasks} Points").font = font_kpi_num
ws_summary.cell(row=7, column=2, value="Across 6 Core Panels").font = font_subtitle

ws_summary.cell(row=5, column=3, value="COMPLETED (COVERED)").font = font_kpi_lbl
ws_summary.cell(row=6, column=3, value=f"{completed_tasks} ({comp_pct}%)").font = Font(name="Calibri", size=22, bold=True, color="15803D")
ws_summary.cell(row=7, column=3, value="100% Tested & Functional").font = font_subtitle

ws_summary.cell(row=5, column=4, value="IN PROGRESS").font = font_kpi_lbl
ws_summary.cell(row=6, column=4, value=f"{in_progress_tasks} ({prog_pct}%)").font = Font(name="Calibri", size=22, bold=True, color="B45309")
ws_summary.cell(row=7, column=4, value="Under active dev/testing").font = font_subtitle

ws_summary.cell(row=5, column=5, value="PENDING / UPCOMING").font = font_kpi_lbl
ws_summary.cell(row=6, column=5, value=f"{pending_tasks} ({pend_pct}%)").font = Font(name="Calibri", size=22, bold=True, color="475569")
ws_summary.cell(row=7, column=5, value="Waiting on 3rd party/store").font = font_subtitle

for col in range(2, 6):
    for r in range(5, 8):
        ws_summary.cell(row=r, column=col).fill = PatternFill(start_color="F8FAFC", end_color="F8FAFC", fill_type="solid")
    ws_summary.cell(row=5, column=col).border = Border(top=Side(style='medium', color="CBD5E1"), left=Side(style='thin', color="E2E8F0"), right=Side(style='thin', color="E2E8F0"))
    ws_summary.cell(row=6, column=col).border = Border(left=Side(style='thin', color="E2E8F0"), right=Side(style='thin', color="E2E8F0"))
    ws_summary.cell(row=7, column=col).border = Border(bottom=Side(style='medium', color="CBD5E1"), left=Side(style='thin', color="E2E8F0"), right=Side(style='thin', color="E2E8F0"))

# Panel Breakdown Table
ws_summary.cell(row=10, column=2, value="Panel-Wise Breakdown Matrix").font = font_section

breakdown_headers = ["Functional Panel", "Completed", "In Progress", "Pending", "Total Points"]
for idx, h in enumerate(breakdown_headers, 2):
    cell = ws_summary.cell(row=12, column=idx, value=h)
    cell.font = font_header
    cell.fill = fill_header
    cell.alignment = Alignment(horizontal="center", vertical="center")
ws_summary.row_dimensions[12].height = 24

panels_list = [
    "Panel 1: Admin Portal (Web)",
    "Panel 2: Partner Portal (Web)",
    "Panel 3: Customer Portal (Web)",
    "Panel 4: Rider Operations (Web)",
    "Panel 5: Backend & APIs",
    "Panel 6: Mobile Apps (Flutter)"
]

current_row = 13
for p_name in panels_list:
    m_comp = sum(1 for t in tasks if t[1].startswith(p_name.split(':')[0]) and t[4] == "Completed")
    m_prog = sum(1 for t in tasks if t[1].startswith(p_name.split(':')[0]) and t[4] == "In Progress")
    m_pend = sum(1 for t in tasks if t[1].startswith(p_name.split(':')[0]) and t[4] == "Pending")
    m_total = m_comp + m_prog + m_pend
    
    ws_summary.cell(row=current_row, column=2, value=p_name).font = font_bold
    ws_summary.cell(row=current_row, column=3, value=m_comp).alignment = Alignment(horizontal="center")
    ws_summary.cell(row=current_row, column=4, value=m_prog).alignment = Alignment(horizontal="center")
    ws_summary.cell(row=current_row, column=5, value=m_pend).alignment = Alignment(horizontal="center")
    ws_summary.cell(row=current_row, column=6, value=m_total).alignment = Alignment(horizontal="center")
    ws_summary.cell(row=current_row, column=6).font = font_bold
    
    for c in range(2, 7):
        ws_summary.cell(row=current_row, column=c).border = border_all
        if current_row % 2 == 1:
            ws_summary.cell(row=current_row, column=c).fill = fill_zebra
    ws_summary.row_dimensions[current_row].height = 22
    current_row += 1

# Total row
ws_summary.cell(row=current_row, column=2, value="TOTAL ALL PANELS").font = font_header
ws_summary.cell(row=current_row, column=3, value=completed_tasks).font = font_header
ws_summary.cell(row=current_row, column=4, value=in_progress_tasks).font = font_header
ws_summary.cell(row=current_row, column=5, value=pending_tasks).font = font_header
ws_summary.cell(row=current_row, column=6, value=total_tasks).font = font_header

for c in range(2, 7):
    ws_summary.cell(row=current_row, column=c).fill = fill_header
    ws_summary.cell(row=current_row, column=c).alignment = Alignment(horizontal="center", vertical="center")
    ws_summary.cell(row=current_row, column=c).border = border_all
ws_summary.row_dimensions[current_row].height = 24

# Save workbook
output_path = "/Users/amankumar/Downloads/avadar_projects/cashify/camsik/Camsik_Project_Status_Report.xlsx"
wb.save(output_path)
print(f"Successfully generated: {output_path}")
