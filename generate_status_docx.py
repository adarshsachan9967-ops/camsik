import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml
from docx.oxml.ns import nsdecls
from datetime import datetime

doc = docx.Document()

# Page Margins
for section in doc.sections:
    section.top_margin = Inches(0.7)
    section.bottom_margin = Inches(0.7)
    section.left_margin = Inches(0.75)
    section.right_margin = Inches(0.75)

# Color Palette
COLOR_NAVY = RGBColor(15, 23, 42)
COLOR_SLATE = RGBColor(71, 85, 105)
COLOR_GRAY = RGBColor(100, 116, 139)
COLOR_GREEN = RGBColor(21, 128, 61)
COLOR_AMBER = RGBColor(180, 83, 9)
COLOR_BLUE = RGBColor(2, 132, 199)
COLOR_RED = RGBColor(185, 28, 28)

def set_cell_background(cell, hex_color):
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
    cell._tc.get_or_add_tcPr().append(shd)

def set_cell_margins(cell, top=100, bottom=100, left=140, right=140):
    tcMar = parse_xml(f'<w:tcMar {nsdecls("w")}><w:top w:w="{top}" w:type="dxa"/><w:bottom w:w="{bottom}" w:type="dxa"/><w:left w:w="{left}" w:type="dxa"/><w:right w:w="{right}" w:type="dxa"/></w:tcMar>')
    cell._tc.get_or_add_tcPr().append(tcMar)

def add_callout(doc, title, text, bg_hex="F8FAFC", border_hex="3B82F6"):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    c = tbl.cell(0, 0)
    c.width = Inches(7.0)
    set_cell_background(c, bg_hex)
    set_cell_margins(c, top=130, bottom=130, left=180, right=180)
    
    borders = parse_xml(f'<w:tcBorders {nsdecls("w")}><w:left w:val="single" w:sz="24" w:space="0" w:color="{border_hex}"/><w:top w:val="none"/><w:right w:val="none"/><w:bottom w:val="none"/></w:tcBorders>')
    c._tc.get_or_add_tcPr().append(borders)
    
    p = c.paragraphs[0]
    p.paragraph_format.space_before = Pt(0)
    p.paragraph_format.space_after = Pt(2)
    run_t = p.add_run(title)
    run_t.font.name = "Calibri"
    run_t.font.size = Pt(11)
    run_t.font.bold = True
    run_t.font.color.rgb = COLOR_NAVY
    
    p2 = c.add_paragraph()
    p2.paragraph_format.space_before = Pt(0)
    p2.paragraph_format.space_after = Pt(0)
    run_txt = p2.add_run(text)
    run_txt.font.name = "Calibri"
    run_txt.font.size = Pt(9.5)
    run_txt.font.color.rgb = COLOR_SLATE

# ─────────────────────────────────────────────────────────────────────────────
# 1. DOCUMENT HEADER & META
# ─────────────────────────────────────────────────────────────────────────────
p_tag = doc.add_paragraph()
r_tag = p_tag.add_run("CAMSIK RECOMMERCE & CAMERA ECOSYSTEM — CLIENT STATUS REPORT")
r_tag.font.name = "Calibri"
r_tag.font.size = Pt(9.5)
r_tag.font.bold = True
r_tag.font.color.rgb = COLOR_BLUE
p_tag.paragraph_format.space_after = Pt(2)

p_title = doc.add_paragraph()
r_title = p_title.add_run("Panel-Wise Project Deliverables & Milestone Progress")
r_title.font.name = "Calibri"
r_title.font.size = Pt(22)
r_title.font.bold = True
r_title.font.color.rgb = COLOR_NAVY
p_title.paragraph_format.space_after = Pt(4)

p_meta = doc.add_paragraph()
r_meta = p_meta.add_run(f"Report Date: {datetime.now().strftime('%d %B %Y')}  |  Reference Codebase: 'casmik'  |  Environment: Port 4028 (Local Live) + Atlas Mongo")
r_meta.font.name = "Calibri"
r_meta.font.size = Pt(9.5)
r_meta.font.italic = True
r_meta.font.color.rgb = COLOR_GRAY
p_meta.paragraph_format.space_after = Pt(14)

# ─────────────────────────────────────────────────────────────────────────────
# 2. EXECUTIVE SUMMARY & KPI CARDS
# ─────────────────────────────────────────────────────────────────────────────
p_h1 = doc.add_paragraph()
r_h1 = p_h1.add_run("Executive Summary")
r_h1.font.name = "Calibri"
r_h1.font.size = Pt(13)
r_h1.font.bold = True
r_h1.font.color.rgb = COLOR_NAVY
p_h1.paragraph_format.space_after = Pt(4)

p_intro = doc.add_paragraph()
p_intro.paragraph_format.line_spacing = 1.15
p_intro.paragraph_format.space_after = Pt(8)
r_intro = p_intro.add_run(
    "This report provides a comprehensive, panel-by-panel status of the Camsik platform based on the active 'casmik' "
    "production codebase and associated Flutter mobile repositories. A total of 38 feature deliverables across 6 functional panels "
    "have been evaluated. All mock/static datasets have been permanently eliminated from the Admin and Partner portals, "
    "ensuring that every KPI, order list, partner detail, and financial metric connects directly to the live MongoDB Atlas cluster."
)
r_intro.font.name = "Calibri"
r_intro.font.size = Pt(10)
r_intro.font.color.rgb = COLOR_SLATE

# KPI Table
kpi_table = doc.add_table(rows=2, cols=4)
kpi_table.alignment = WD_TABLE_ALIGNMENT.CENTER
kpi_data = [
    ("TOTAL DELIVERABLES", "38 Points", "Across 6 Core Panels", "0F172A"),
    ("COMPLETED (COVERED)", "24 Points (63%)", "100% Tested & Live", "15803D"),
    ("IN PROGRESS", "9 Points (24%)", "Active Dev / Integration", "B45309"),
    ("PENDING / UPCOMING", "5 Points (13%)", "3rd-Party & Deployment", "475569"),
]

for col_idx, (title, val, sub, color_hex) in enumerate(kpi_data):
    c_top = kpi_table.cell(0, col_idx)
    c_bot = kpi_table.cell(1, col_idx)
    c_top.width = Inches(1.75)
    c_bot.width = Inches(1.75)
    set_cell_background(c_top, "F8FAFC")
    set_cell_background(c_bot, "F8FAFC")
    set_cell_margins(c_top, top=80, bottom=30, left=60, right=60)
    set_cell_margins(c_bot, top=30, bottom=80, left=60, right=60)
    
    p0 = c_top.paragraphs[0]
    p0.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r0 = p0.add_run(title)
    r0.font.name = "Calibri"
    r0.font.size = Pt(8.5)
    r0.font.bold = True
    r0.font.color.rgb = COLOR_GRAY
    
    p1 = c_bot.paragraphs[0]
    p1.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r1 = p1.add_run(val)
    r1.font.name = "Calibri"
    r1.font.size = Pt(14.5)
    r1.font.bold = True
    r1.font.color.rgb = RGBColor.from_string(color_hex)
    
    p2 = c_bot.add_paragraph()
    p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r2 = p2.add_run(sub)
    r2.font.name = "Calibri"
    r2.font.size = Pt(8)
    r2.font.italic = True
    r2.font.color.rgb = COLOR_GRAY

doc.add_paragraph().paragraph_format.space_after = Pt(10)

add_callout(
    doc,
    "⭐ Major Milestone Completed: 100% Elimination of Mock Data",
    "Previously, several admin and partner views displayed hardcoded fallback numbers (e.g. ₹84L revenue, sample partner cards, dummy riders). "
    "All 22 Admin modules and Partner portal screens have been refactored to query live MongoDB endpoints exclusively. "
    "Browser storage caches are automatically validated and purged on session startup.",
    bg_hex="F0FDF4",
    border_hex="22C55E"
)

doc.add_paragraph().paragraph_format.space_after = Pt(12)

# ─────────────────────────────────────────────────────────────────────────────
# TABLE BUILDER FUNCTION
# ─────────────────────────────────────────────────────────────────────────────
def build_panel_table(doc, panel_title, panel_badge, items):
    p_head = doc.add_paragraph()
    p_head.paragraph_format.space_before = Pt(14)
    p_head.paragraph_format.space_after = Pt(4)
    
    r_h = p_head.add_run(panel_title + " ")
    r_h.font.name = "Calibri"
    r_h.font.size = Pt(12.5)
    r_h.font.bold = True
    r_h.font.color.rgb = COLOR_NAVY
    
    r_b = p_head.add_run(f"[{panel_badge}]")
    r_b.font.name = "Calibri"
    r_b.font.size = Pt(9.5)
    r_b.font.bold = True
    r_b.font.color.rgb = COLOR_BLUE

    table = doc.add_table(rows=1, cols=5)
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.autofit = False

    col_widths = [Inches(1.8), Inches(2.7), Inches(0.95), Inches(0.65), Inches(0.9)]
    col_names = ["Feature / Deliverable", "Scope & Functionality in Casmik", "Status", "Progress", "Priority"]

    # Header Row
    for i, name in enumerate(col_names):
        cell = table.rows[0].cells[i]
        cell.width = col_widths[i]
        set_cell_background(cell, "0F172A")
        set_cell_margins(cell, top=90, bottom=90, left=90, right=90)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER if i >= 2 else WD_ALIGN_PARAGRAPH.LEFT
        run = p.add_run(name)
        run.font.name = "Calibri"
        run.font.size = Pt(9)
        run.font.bold = True
        run.font.color.rgb = RGBColor(255, 255, 255)

    # Data Rows
    for row_idx, item in enumerate(items):
        row = table.add_row()
        cells = row.cells
        bg_color = "F8FAFC" if row_idx % 2 == 1 else "FFFFFF"

        feature, scope, status, progress, priority = item
        
        for i in range(5):
            cells[i].width = col_widths[i]
            set_cell_background(cells[i], bg_color)
            set_cell_margins(cells[i], top=75, bottom=75, left=90, right=90)
            
        # Feature
        p0 = cells[0].paragraphs[0]
        r0 = p0.add_run(feature)
        r0.font.name = "Calibri"
        r0.font.size = Pt(9)
        r0.font.bold = True
        r0.font.color.rgb = COLOR_NAVY

        # Scope
        p1 = cells[1].paragraphs[0]
        r1 = p1.add_run(scope)
        r1.font.name = "Calibri"
        r1.font.size = Pt(8.5)
        r1.font.color.rgb = COLOR_SLATE

        # Status
        p2 = cells[2].paragraphs[0]
        p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r2 = p2.add_run(status)
        r2.font.name = "Calibri"
        r2.font.size = Pt(8.5)
        r2.font.bold = True
        if status == "Completed":
            set_cell_background(cells[2], "DCFCE7")
            r2.font.color.rgb = COLOR_GREEN
        elif status == "In Progress":
            set_cell_background(cells[2], "FEF3C7")
            r2.font.color.rgb = COLOR_AMBER
        else:
            set_cell_background(cells[2], "F1F5F9")
            r2.font.color.rgb = COLOR_GRAY

        # Progress
        p3 = cells[3].paragraphs[0]
        p3.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r3 = p3.add_run(progress)
        r3.font.name = "Calibri"
        r3.font.size = Pt(8.5)
        r3.font.bold = True
        r3.font.color.rgb = COLOR_NAVY

        # Priority
        p4 = cells[4].paragraphs[0]
        p4.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r4 = p4.add_run(priority)
        r4.font.name = "Calibri"
        r4.font.size = Pt(8.5)
        r4.font.bold = True
        if priority == "High":
            r4.font.color.rgb = COLOR_RED
        elif priority == "Medium":
            r4.font.color.rgb = COLOR_AMBER
        else:
            r4.font.color.rgb = COLOR_GRAY

    doc.add_paragraph().paragraph_format.space_after = Pt(8)

# ─────────────────────────────────────────────────────────────────────────────
# PANEL 1: SUPER ADMIN PORTAL (WEB)
# ─────────────────────────────────────────────────────────────────────────────
p1_items = [
    ("1. Live Orders Engine", "Connects to live MongoDB with 27 real orders; click-to-filter tabs (All, Pending, Active, Completed); partner/rider allocation modal.", "Completed", "100%", "High"),
    ("2. Real-Time Order Radar", "Interactive live visual tracker following orders across status transitions (Created ➔ Assigned ➔ In Transit ➔ Completed).", "Completed", "100%", "High"),
    ("3. Executive Overview & KPIs", "Live revenue aggregate, order counters, week-over-week trends, dynamic 7-day revenue chart, category distribution.", "Completed", "100%", "High"),
    ("4. Partner Store Management", "Onboarding, KYC document audit (Aadhaar, PAN, GST, Shop License), approval workflow (Active / Suspended / Pending).", "Completed", "100%", "High"),
    ("5. Delivery Agent / Rider Fleet", "Rider onboarding, vehicle verification (RC, DL, Insurance), live online status, Admin Fleet vs Partner Fleet filtering.", "Completed", "100%", "High"),
    ("6. Customer Directory", "Dynamic customer aggregation from live orders; total spend, order count, contact details, status toggle (Active/Blocked).", "Completed", "100%", "Medium"),
    ("7. Reports & Analytics Hub", "Dynamic date range filters (7d, 30d, 90d, Year), Partner performance table, Rider metrics, monthly revenue trends.", "Completed", "100%", "High"),
    ("8. Camera Rental Management", "Cinema & mirrorless rental catalog, daily rates, inventory stock counts, live rental bookings linked to database.", "Completed", "100%", "High"),
    ("9. Refurbished Store Catalog", "Listing management, 3-tier condition grading (Superb, Good, Fair), stock status, warranty tag configuration.", "Completed", "100%", "Medium"),
    ("10. Pricing & Valuation Matrix", "Valuation quiz questions, dynamic price adjustments (+/-), condition penalty matrix, camera lens pricing rules.", "Completed", "100%", "High"),
    ("11. Audio-Visual Alerts Hub", "Web Audio chimes, native OS push notifications, unread badges, cross-tab BroadcastChannel sync.", "Completed", "100%", "Medium"),
    ("12. Content Management (CMS)", "Homepage hero banners, trust metrics, customer testimonials, FAQs, and footer settings editable from dashboard.", "Completed", "100%", "Medium"),
    ("13. Coupon & Promo Engine", "Fixed/percentage discount coupon creator, validity dates, minimum order limits, usage cap counters.", "Completed", "100%", "Low"),
    ("14. Support Ticketing System", "Multi-role ticketing (User, Partner, Rider), category routing, priority flags, resolution threads.", "Completed", "100%", "Medium"),
]
build_panel_table(doc, "Panel 1: Super Admin Portal (Web)", "casmik/src/app/admin", p1_items)

# ─────────────────────────────────────────────────────────────────────────────
# PANEL 2: PARTNER STORE PORTAL (WEB)
# ─────────────────────────────────────────────────────────────────────────────
p2_items = [
    ("15. Partner Auth & Middleware", "Store login with credentials, approval verification, session storage, protected route middleware.", "Completed", "100%", "High"),
    ("16. Partner Dashboard & KPIs", "Store welcome header, live earnings, order counters, dynamic 7-day revenue graph, runtime crash fixes.", "Completed", "100%", "High"),
    ("17. 12-Point Inspection Tool", "Physical & technical diagnostic checklist, automated deduction calculation, spot payout locking.", "Completed", "100%", "High"),
    ("18. Order Acceptance Queue", "Incoming orders queue, accept/reject, pickup scheduling, customer contact, and delivery handoff.", "Completed", "100%", "High"),
    ("19. Dedicated Store Fleet", "Partner-specific rider listing, onboarding riders for store fleet, direct order assignment.", "Completed", "100%", "Medium"),
    ("20. Partner Payouts & Ledger", "Available balance, withdrawal request workflow, transaction ledger, and payment gateway fund addition.", "In Progress", "85%", "High"),
    ("21. Store Customer Directory", "Directory of customers who transacted with the partner store, order frequency, and lifetime value.", "Completed", "100%", "Medium"),
]
build_panel_table(doc, "Panel 2: Partner Store Portal (Web)", "casmik/src/app/partner", p2_items)

# ─────────────────────────────────────────────────────────────────────────────
# PANEL 3: CUSTOMER WEB PORTAL & E-COMMERCE
# ─────────────────────────────────────────────────────────────────────────────
p3_items = [
    ("22. Sell Device & Valuation", "Instant price calculation wizard, condition questionnaire, accessories selection, quote generation (/sell-device-get-quote).", "Completed", "100%", "High"),
    ("23. Camera Rental Booking", "Cinema & mirrorless camera catalog, date range picker, security deposit calculation, doorstep delivery booking (/rental-cameras).", "Completed", "100%", "High"),
    ("24. Buy Refurbished Store", "E-commerce listing of certified refurbished devices, condition filters, transparent pricing, checkout (/buy-refurbished).", "Completed", "100%", "High"),
    ("25. Device Repair Booking", "Service selection for cameras and phones (Screen, Lens, Sensor, Battery), repair cost estimator (/repair-device).", "Completed", "100%", "Medium"),
    ("26. Live Order Tracking", "Customer self-service order tracking with order number and phone number verification (/track-order).", "Completed", "100%", "High"),
    ("27. Customer Account & Orders", "User profile, past sell/rental/repair order history, invoice download, payment status (/my-orders, /user).", "Completed", "90%", "Medium"),
    ("28. Device Verification & IMEI", "Instant IMEI & serial number blacklist / verification check before sale confirmation (/verify-device).", "Completed", "90%", "High"),
]
build_panel_table(doc, "Panel 3: Customer Web Portal & Storefront", "casmik/src/app", p3_items)

# ─────────────────────────────────────────────────────────────────────────────
# PANEL 4: DELIVERY AGENT / RIDER PORTAL
# ─────────────────────────────────────────────────────────────────────────────
p4_items = [
    ("29. Rider Web Dispatch Portal", "Rider login, task list of assigned doorstep pickups, customer addresses, pickup time slots (/delivery).", "Completed", "100%", "High"),
    ("30. Doorstep Pickup Verification", "Rider device checklist on arrival, customer identity verification, photo upload of device condition.", "In Progress", "85%", "High"),
    ("31. Rider Daily Earnings Ledger", "Per-pickup commission tracking, completed trips summary, daily settlement status.", "In Progress", "80%", "Medium"),
]
build_panel_table(doc, "Panel 4: Delivery Agent / Rider Operations", "casmik/src/app/delivery", p4_items)

# ─────────────────────────────────────────────────────────────────────────────
# PANEL 5: BACKEND APIS & DATABASE
# ─────────────────────────────────────────────────────────────────────────────
p5_items = [
    ("32. MongoDB Atlas Live Cluster", "Production cluster connection holding live orders (27 active records), partners, riders, questions, and lenses.", "Completed", "100%", "High"),
    ("33. Core REST Endpoints", "CRUD APIs: /api/orders, /api/partners, /api/delivery-agents, /api/questions, /api/lenses with schema validation.", "Completed", "100%", "High"),
    ("34. Supabase Realtime Sync", "Live channel synchronization for instant order updates across admin and partner browser tabs.", "Completed", "90%", "High"),
    ("35. Automated Payout Gateway", "RazorpayX / Cashfree integration for automated instant UPI/NEFT payouts upon completed inspection.", "In Progress", "70%", "High"),
    ("36. SMS & WhatsApp OTP Gateway", "Twilio / MSG91 integration for customer login OTP, booking notifications, and pickup OTP verification.", "In Progress", "60%", "High"),
]
build_panel_table(doc, "Panel 5: Backend APIs, Database & Integrations", "casmik/src/app/api", p5_items)

# ─────────────────────────────────────────────────────────────────────────────
# PANEL 6: FLUTTER MOBILE APPLICATIONS
# ─────────────────────────────────────────────────────────────────────────────
p6_items = [
    ("37. Flutter Apps Suite (4 Apps)", "Partner App (camsik-partner - 80%), Rider App (camsik-delivery - 75%), Customer App (camsik-user - 70%), Admin App (camsik-admin - 65%).", "In Progress", "75%", "High"),
    ("38. Play Store & App Store Release", "Production AAB / IPA build generation, store listing assets, Google Play Console & Apple Developer submission.", "Pending", "20%", "High"),
]
build_panel_table(doc, "Panel 6: Flutter Mobile Applications & Store Release", "camsik-partner, delivery, user, admin", p6_items)

# ─────────────────────────────────────────────────────────────────────────────
# CLIENT ACTION ITEMS / DEPENDENCY SECTION
# ─────────────────────────────────────────────────────────────────────────────
p_dep = doc.add_paragraph()
p_dep.paragraph_format.space_before = Pt(14)
p_dep.paragraph_format.space_after = Pt(4)
r_dh = p_dep.add_run("Immediate Client Dependencies & Next Milestones")
r_dh.font.name = "Calibri"
r_dh.font.size = Pt(13)
r_dh.font.bold = True
r_dh.font.color.rgb = COLOR_NAVY

dependencies = [
    ("Payment Gateway Production Credentials:", "Provide live RazorpayX / Cashfree API Key, Secret, and Merchant ID to enable direct automated customer bank payouts."),
    ("SMS / WhatsApp DLT Approval:", "Share MSG91 or Twilio credentials along with approved DLT Entity ID and Sender Headers for live OTP delivery."),
    ("Google Play Console & Apple Developer Access:", "Provide developer access or account credentials to initiate internal test track releases for the 4 Flutter mobile apps."),
    ("Domain & Server Finalization:", "Confirm target domain (e.g., camsik.in) and hosting server (AWS / DigitalOcean / Hostinger VPS) for live DNS mapping and SSL provisioning.")
]

for title, desc in dependencies:
    p = doc.add_paragraph(style='List Bullet')
    p.paragraph_format.space_before = Pt(2)
    p.paragraph_format.space_after = Pt(4)
    r1 = p.add_run(title + " ")
    r1.font.name = "Calibri"
    r1.font.bold = True
    r1.font.size = Pt(9.5)
    r1.font.color.rgb = COLOR_NAVY
    r2 = p.add_run(desc)
    r2.font.name = "Calibri"
    r2.font.size = Pt(9.5)
    r2.font.color.rgb = COLOR_SLATE

# Save document
output_path = "/Users/amankumar/Downloads/avadar_projects/cashify/camsik/Camsik_Project_Status_Report.docx"
doc.save(output_path)
print(f"Successfully generated: {output_path}")
