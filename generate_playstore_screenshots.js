const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const outputDir = path.resolve(__dirname, 'release-apks', 'admin-screenshots', 'compliant-store-screenshots');
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

const screens = [
  {
    id: '01_dashboard_overview',
    title: 'Central Ecosystem Hub',
    tabIndex: 0,
    renderContent: `
      <!-- GMV Banner -->
      <div style="background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%); border-radius: 28px; padding: 32px; color: white; box-shadow: 0 12px 32px rgba(124,58,237,0.35); margin-bottom: 24px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
          <span style="font-size: 14px; font-weight: 700; letter-spacing: 1.5px; opacity: 0.85;">TOTAL PLATFORM GMV</span>
          <span style="background: rgba(255,255,255,0.22); padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 600;">● LIVE ECOSYSTEM</span>
        </div>
        <div style="font-size: 52px; font-weight: 900; letter-spacing: -1px; margin-bottom: 18px;">₹30,72,500</div>
        <div style="display: flex; gap: 24px; font-size: 16px; opacity: 0.9; border-top: 1px solid rgba(255,255,255,0.2); padding-top: 16px;">
          <div>Today: <strong style="font-weight: 700;">36 orders</strong></div>
          <div>•</div>
          <div>Active Volume: <strong style="font-weight: 700;">₹3,40,000</strong></div>
        </div>
      </div>

      <!-- Quick Metrics Grid -->
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-bottom: 28px;">
        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.04);">
          <div style="width: 48px; height: 48px; border-radius: 14px; background: #EDE9FE; display: flex; align-items: center; justify-content: center; margin-bottom: 14px;">
            <svg width="26" height="26" fill="#7C3AED" viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
          </div>
          <div style="font-size: 32px; font-weight: 800; color: #0F172A;">1,420</div>
          <div style="font-size: 15px; color: #64748B; font-weight: 500; margin-top: 4px;">Total Orders</div>
        </div>
        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.04);">
          <div style="width: 48px; height: 48px; border-radius: 14px; background: #DBEAFE; display: flex; align-items: center; justify-content: center; margin-bottom: 14px;">
            <svg width="26" height="26" fill="#2563EB" viewBox="0 0 24 24"><path d="M15.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM5 12c-2.8 0-5 2.2-5 5s2.2 5 5 5 5-2.2 5-5-2.2-5-5-5zm0 8.5c-1.9 0-3.5-1.6-3.5-3.5s1.6-3.5 3.5-3.5 3.5 1.6 3.5 3.5-1.6 3.5-3.5 3.5zm14-8.5c-2.8 0-5 2.2-5 5s2.2 5 5 5 5-2.2 5-5-2.2-5-5-5zm0 8.5c-1.9 0-3.5-1.6-3.5-3.5s1.6-3.5 3.5-3.5 3.5 1.6 3.5 3.5-1.6 3.5-3.5 3.5zM10.8 10.5l2.4-4.5 1.8 1.8V12h2V7.4l-2.6-2.6c-.4-.4-1-.4-1.4 0l-3.2 6H5v2h4.5l1.3-2.3z"/></svg>
          </div>
          <div style="font-size: 32px; font-weight: 800; color: #0F172A;">18</div>
          <div style="font-size: 15px; color: #64748B; font-weight: 500; margin-top: 4px;">Active Fleet Riders</div>
        </div>
        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.04);">
          <div style="width: 48px; height: 48px; border-radius: 14px; background: #DCFCE7; display: flex; align-items: center; justify-content: center; margin-bottom: 14px;">
            <svg width="26" height="26" fill="#10B981" viewBox="0 0 24 24"><path d="M20 4H4v2h16V4zm1 10v-2l-1-5H4l-1 5v2h1v6h10v-6h4v6h2v-6h1zm-9 4H6v-4h6v4z"/></svg>
          </div>
          <div style="font-size: 32px; font-weight: 800; color: #0F172A;">42</div>
          <div style="font-size: 15px; color: #64748B; font-weight: 500; margin-top: 4px;">Partner Stores</div>
        </div>
        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.04);">
          <div style="width: 48px; height: 48px; border-radius: 14px; background: #FEF3C7; display: flex; align-items: center; justify-content: center; margin-bottom: 14px;">
            <svg width="26" height="26" fill="#F59E0B" viewBox="0 0 24 24"><path d="M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/></svg>
          </div>
          <div style="font-size: 32px; font-weight: 800; color: #0F172A;">9</div>
          <div style="font-size: 15px; color: #64748B; font-weight: 500; margin-top: 4px;">In-Transit Pickups</div>
        </div>
      </div>

      <!-- Section Title -->
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
        <span style="font-size: 20px; font-weight: 800; color: #0F172A;">Recent Activity</span>
        <span style="font-size: 14px; color: #7C3AED; font-weight: 600;">View Orders →</span>
      </div>

      <!-- Activity List -->
      <div style="display: flex; flex-direction: column; gap: 14px;">
        <div style="background: white; border-radius: 20px; padding: 20px 22px; border: 1px solid #E2E8F0; display: flex; align-items: center; justify-content: space-between;">
          <div>
            <div style="display: flex; align-items: center; gap: 10px;">
              <span style="font-size: 16px; font-weight: 800; color: #0F172A;">CSM-2026-104</span>
              <span style="background: #FEF3C7; color: #B45309; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 700;">PICKUP ASSIGNED</span>
            </div>
            <div style="font-size: 14px; color: #64748B; margin-top: 6px;">Sony Alpha A7 III • Rajesh Sharma (Mumbai)</div>
          </div>
          <div style="text-align: right;">
            <div style="font-size: 18px; font-weight: 800; color: #0F172A;">₹54,500</div>
            <div style="font-size: 12px; color: #94A3B8; margin-top: 4px;">12m ago</div>
          </div>
        </div>

        <div style="background: white; border-radius: 20px; padding: 20px 22px; border: 1px solid #E2E8F0; display: flex; align-items: center; justify-content: space-between;">
          <div>
            <div style="display: flex; align-items: center; gap: 10px;">
              <span style="font-size: 16px; font-weight: 800; color: #0F172A;">CSM-2026-103</span>
              <span style="background: #DBEAFE; color: #1E40AF; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 700;">INSPECTION</span>
            </div>
            <div style="font-size: 14px; color: #64748B; margin-top: 6px;">Canon EOS R6 • Amit Patel (Pune)</div>
          </div>
          <div style="text-align: right;">
            <div style="font-size: 18px; font-weight: 800; color: #0F172A;">₹82,000</div>
            <div style="font-size: 12px; color: #94A3B8; margin-top: 4px;">45m ago</div>
          </div>
        </div>

        <div style="background: white; border-radius: 20px; padding: 20px 22px; border: 1px solid #E2E8F0; display: flex; align-items: center; justify-content: space-between;">
          <div>
            <div style="display: flex; align-items: center; gap: 10px;">
              <span style="font-size: 16px; font-weight: 800; color: #0F172A;">CSM-2026-102</span>
              <span style="background: #DCFCE7; color: #166534; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 700;">COMPLETED</span>
            </div>
            <div style="font-size: 14px; color: #64748B; margin-top: 6px;">Nikon Z6 II • Priya Menon (Bangalore)</div>
          </div>
          <div style="text-align: right;">
            <div style="font-size: 18px; font-weight: 800; color: #0F172A;">₹64,000</div>
            <div style="font-size: 12px; color: #94A3B8; margin-top: 4px;">2h ago</div>
          </div>
        </div>
      </div>
    `
  },
  {
    id: '02_orders_management',
    title: 'Orders Command Center',
    tabIndex: 1,
    renderContent: `
      <!-- Search Input -->
      <div style="background: white; border-radius: 16px; padding: 16px 20px; border: 1px solid #E2E8F0; display: flex; align-items: center; gap: 14px; margin-bottom: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.03);">
        <svg width="22" height="22" fill="#64748B" viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
        <span style="font-size: 16px; color: #94A3B8;">Search Order ID, Customer, Model...</span>
      </div>

      <!-- Filter Pills -->
      <div style="display: flex; gap: 10px; overflow-x: auto; margin-bottom: 24px; padding-bottom: 4px;">
        <span style="background: #7C3AED; color: white; padding: 10px 22px; border-radius: 24px; font-size: 14px; font-weight: 700; white-space: nowrap;">All Orders (142)</span>
        <span style="background: white; color: #64748B; border: 1px solid #CBD5E1; padding: 10px 20px; border-radius: 24px; font-size: 14px; font-weight: 600; white-space: nowrap;">Pickup (18)</span>
        <span style="background: white; color: #64748B; border: 1px solid #CBD5E1; padding: 10px 20px; border-radius: 24px; font-size: 14px; font-weight: 600; white-space: nowrap;">In Transit (9)</span>
        <span style="background: white; color: #64748B; border: 1px solid #CBD5E1; padding: 10px 20px; border-radius: 24px; font-size: 14px; font-weight: 600; white-space: nowrap;">Inspection (12)</span>
        <span style="background: white; color: #64748B; border: 1px solid #CBD5E1; padding: 10px 20px; border-radius: 24px; font-size: 14px; font-weight: 600; white-space: nowrap;">Completed (96)</span>
      </div>

      <!-- Orders List -->
      <div style="display: flex; flex-direction: column; gap: 18px;">
        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
          <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #F1F5F9; padding-bottom: 14px; margin-bottom: 14px;">
            <div>
              <span style="font-size: 17px; font-weight: 800; color: #0F172A;">CSM-2026-104</span>
              <span style="font-size: 13px; color: #94A3B8; margin-left: 8px;">• Sell Order</span>
            </div>
            <span style="background: #FEF3C7; color: #B45309; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700;">Out for Pickup</span>
          </div>
          <div style="font-size: 18px; font-weight: 700; color: #0F172A; margin-bottom: 8px;">Sony Alpha A7 III (Body Only)</div>
          <div style="font-size: 14px; color: #64748B; line-height: 1.6; margin-bottom: 16px;">
            <div>Customer: <strong>Rajesh Sharma</strong> (+91 98765 43210)</div>
            <div>Partner Store: <strong>Camsik Hub Mumbai Central</strong></div>
            <div>Assigned Fleet: <strong>Vikram Singh</strong> (MH-01-AB-1234)</div>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #F1F5F9; padding-top: 14px;">
            <div>
              <span style="font-size: 12px; color: #94A3B8;">PAYOUT VALUE</span>
              <div style="font-size: 22px; font-weight: 800; color: #7C3AED;">₹54,500</div>
            </div>
            <span style="background: #EDE9FE; color: #7C3AED; padding: 8px 18px; border-radius: 12px; font-size: 13px; font-weight: 700;">Manage Order →</span>
          </div>
        </div>

        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
          <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #F1F5F9; padding-bottom: 14px; margin-bottom: 14px;">
            <div>
              <span style="font-size: 17px; font-weight: 800; color: #0F172A;">CSM-2026-103</span>
              <span style="font-size: 13px; color: #94A3B8; margin-left: 8px;">• Sell Order</span>
            </div>
            <span style="background: #DBEAFE; color: #1E40AF; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700;">In Inspection</span>
          </div>
          <div style="font-size: 18px; font-weight: 700; color: #0F172A; margin-bottom: 8px;">Canon EOS R6 Mirrorless 24-105mm</div>
          <div style="font-size: 14px; color: #64748B; line-height: 1.6; margin-bottom: 16px;">
            <div>Customer: <strong>Amit Patel</strong> (+91 98234 56789)</div>
            <div>Partner Store: <strong>Camsik Pune FC Hub</strong></div>
            <div>Assigned Fleet: <strong>Rohit Verma</strong> (MH-12-CD-5678)</div>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #F1F5F9; padding-top: 14px;">
            <div>
              <span style="font-size: 12px; color: #94A3B8;">PAYOUT VALUE</span>
              <div style="font-size: 22px; font-weight: 800; color: #7C3AED;">₹82,000</div>
            </div>
            <span style="background: #EDE9FE; color: #7C3AED; padding: 8px 18px; border-radius: 12px; font-size: 13px; font-weight: 700;">Manage Order →</span>
          </div>
        </div>
      </div>
    `
  },
  {
    id: '03_partners_network',
    title: 'Partner Stores Network',
    tabIndex: 2,
    renderContent: `
      <!-- Search Input -->
      <div style="background: white; border-radius: 16px; padding: 16px 20px; border: 1px solid #E2E8F0; display: flex; align-items: center; gap: 14px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.03);">
        <svg width="22" height="22" fill="#64748B" viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
        <span style="font-size: 16px; color: #94A3B8;">Search Store Name, Owner, City...</span>
      </div>

      <!-- Partners List -->
      <div style="display: flex; flex-direction: column; gap: 18px;">
        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
          <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
            <div style="display: flex; gap: 14px; align-items: center;">
              <div style="width: 48px; height: 48px; border-radius: 14px; background: #EDE9FE; display: flex; align-items: center; justify-content: center;">
                <svg width="26" height="26" fill="#7C3AED" viewBox="0 0 24 24"><path d="M20 4H4v2h16V4zm1 10v-2l-1-5H4l-1 5v2h1v6h10v-6h4v6h2v-6h1zm-9 4H6v-4h6v4z"/></svg>
              </div>
              <div>
                <div style="font-size: 18px; font-weight: 800; color: #0F172A;">Apex Camera Care & Sales</div>
                <div style="font-size: 14px; color: #64748B;">Mumbai Central, Maharashtra</div>
              </div>
            </div>
            <span style="background: #DCFCE7; color: #166534; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700;">✓ Verified</span>
          </div>
          <div style="background: #F8FAFC; border-radius: 16px; padding: 14px 18px; display: flex; justify-content: space-between; font-size: 14px; color: #475569; margin: 14px 0;">
            <div>Owner: <strong>Ramesh Gupta</strong></div>
            <div>Phone: <strong>+91 98201 12345</strong></div>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #F1F5F9; padding-top: 14px;">
            <span style="font-size: 14px; color: #64748B;">14 Active Orders • ₹18.4L GMV</span>
            <span style="color: #7C3AED; font-weight: 700; font-size: 14px;">Store Details →</span>
          </div>
        </div>

        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
          <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
            <div style="display: flex; gap: 14px; align-items: center;">
              <div style="width: 48px; height: 48px; border-radius: 14px; background: #DBEAFE; display: flex; align-items: center; justify-content: center;">
                <svg width="26" height="26" fill="#2563EB" viewBox="0 0 24 24"><path d="M20 4H4v2h16V4zm1 10v-2l-1-5H4l-1 5v2h1v6h10v-6h4v6h2v-6h1zm-9 4H6v-4h6v4z"/></svg>
              </div>
              <div>
                <div style="font-size: 18px; font-weight: 800; color: #0F172A;">Metro Optics & Gear Hub</div>
                <div style="font-size: 14px; color: #64748B;">FC Road, Pune, Maharashtra</div>
              </div>
            </div>
            <span style="background: #DCFCE7; color: #166534; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700;">✓ Verified</span>
          </div>
          <div style="background: #F8FAFC; border-radius: 16px; padding: 14px 18px; display: flex; justify-content: space-between; font-size: 14px; color: #475569; margin: 14px 0;">
            <div>Owner: <strong>Sunil Kulkarni</strong></div>
            <div>Phone: <strong>+91 98220 54321</strong></div>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #F1F5F9; padding-top: 14px;">
            <span style="font-size: 14px; color: #64748B;">9 Active Orders • ₹12.1L GMV</span>
            <span style="color: #7C3AED; font-weight: 700; font-size: 14px;">Store Details →</span>
          </div>
        </div>

        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
          <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
            <div style="display: flex; gap: 14px; align-items: center;">
              <div style="width: 48px; height: 48px; border-radius: 14px; background: #DCFCE7; display: flex; align-items: center; justify-content: center;">
                <svg width="26" height="26" fill="#10B981" viewBox="0 0 24 24"><path d="M20 4H4v2h16V4zm1 10v-2l-1-5H4l-1 5v2h1v6h10v-6h4v6h2v-6h1zm-9 4H6v-4h6v4z"/></svg>
              </div>
              <div>
                <div style="font-size: 18px; font-weight: 800; color: #0F172A;">LensCraft Digital Studio</div>
                <div style="font-size: 14px; color: #64748B;">Indiranagar, Bangalore, Karnataka</div>
              </div>
            </div>
            <span style="background: #DCFCE7; color: #166534; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700;">✓ Verified</span>
          </div>
          <div style="background: #F8FAFC; border-radius: 16px; padding: 14px 18px; display: flex; justify-content: space-between; font-size: 14px; color: #475569; margin: 14px 0;">
            <div>Owner: <strong>Ananya Roy</strong></div>
            <div>Phone: <strong>+91 98450 98765</strong></div>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #F1F5F9; padding-top: 14px;">
            <span style="font-size: 14px; color: #64748B;">11 Active Orders • ₹15.8L GMV</span>
            <span style="color: #7C3AED; font-weight: 700; font-size: 14px;">Store Details →</span>
          </div>
        </div>
      </div>
    `
  },
  {
    id: '04_fleet_logistics',
    title: 'Field Fleet Logistics',
    tabIndex: 3,
    renderContent: `
      <!-- Search Input -->
      <div style="background: white; border-radius: 16px; padding: 16px 20px; border: 1px solid #E2E8F0; display: flex; align-items: center; gap: 14px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.03);">
        <svg width="22" height="22" fill="#64748B" viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
        <span style="font-size: 16px; color: #94A3B8;">Search Rider Name, Phone, Zone...</span>
      </div>

      <!-- Fleet Riders List -->
      <div style="display: flex; flex-direction: column; gap: 18px;">
        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
            <div style="display: flex; gap: 14px; align-items: center;">
              <div style="width: 48px; height: 48px; border-radius: 50%; background: #EDE9FE; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 800; color: #7C3AED;">
                VS
              </div>
              <div>
                <div style="font-size: 18px; font-weight: 800; color: #0F172A;">Vikram Singh</div>
                <div style="font-size: 14px; color: #64748B;">Zone: Mumbai South • +91 98200 44556</div>
              </div>
            </div>
            <span style="background: #DCFCE7; color: #166534; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700;">● Online (Active)</span>
          </div>
          <div style="background: #F8FAFC; border-radius: 16px; padding: 14px 18px; font-size: 14px; color: #475569; margin: 12px 0;">
            <div>Vehicle: <strong>Honda Activa (MH-01-AB-1234)</strong></div>
            <div style="margin-top: 6px;">Current Assignment: <strong>Order #CSM-2026-104 (Pickup)</strong></div>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #F1F5F9; padding-top: 14px;">
            <span style="font-size: 14px; color: #10B981; font-weight: 600;">6 Deliveries Completed Today</span>
            <span style="color: #7C3AED; font-weight: 700; font-size: 14px;">Live Track →</span>
          </div>
        </div>

        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
            <div style="display: flex; gap: 14px; align-items: center;">
              <div style="width: 48px; height: 48px; border-radius: 50%; background: #DBEAFE; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 800; color: #2563EB;">
                RV
              </div>
              <div>
                <div style="font-size: 18px; font-weight: 800; color: #0F172A;">Rohit Verma</div>
                <div style="font-size: 14px; color: #64748B;">Zone: Pune East • +91 98230 77889</div>
              </div>
            </div>
            <span style="background: #DCFCE7; color: #166534; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700;">● Online (Active)</span>
          </div>
          <div style="background: #F8FAFC; border-radius: 16px; padding: 14px 18px; font-size: 14px; color: #475569; margin: 12px 0;">
            <div>Vehicle: <strong>Bajaj Pulsar (MH-12-CD-5678)</strong></div>
            <div style="margin-top: 6px;">Current Assignment: <strong>Order #CSM-2026-103 (Inspection)</strong></div>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #F1F5F9; padding-top: 14px;">
            <span style="font-size: 14px; color: #10B981; font-weight: 600;">4 Deliveries Completed Today</span>
            <span style="color: #7C3AED; font-weight: 700; font-size: 14px;">Live Track →</span>
          </div>
        </div>

        <div style="background: white; border-radius: 22px; padding: 24px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
            <div style="display: flex; gap: 14px; align-items: center;">
              <div style="width: 48px; height: 48px; border-radius: 50%; background: #DCFCE7; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 800; color: #10B981;">
                SK
              </div>
              <div>
                <div style="font-size: 18px; font-weight: 800; color: #0F172A;">Suresh Kumar</div>
                <div style="font-size: 14px; color: #64748B;">Zone: Bangalore South • +91 98450 33221</div>
              </div>
            </div>
            <span style="background: #FEF3C7; color: #B45309; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 700;">Idle (Available)</span>
          </div>
          <div style="background: #F8FAFC; border-radius: 16px; padding: 14px 18px; font-size: 14px; color: #475569; margin: 12px 0;">
            <div>Vehicle: <strong>TVS Jupiter (KA-01-EF-9012)</strong></div>
            <div style="margin-top: 6px;">Status: <strong>Ready for next order assignment</strong></div>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #F1F5F9; padding-top: 14px;">
            <span style="font-size: 14px; color: #10B981; font-weight: 600;">8 Deliveries Completed Today</span>
            <span style="color: #7C3AED; font-weight: 700; font-size: 14px;">Assign Order →</span>
          </div>
        </div>
      </div>
    `
  },
  {
    id: '05_system_controls',
    title: 'Admin System & Controls',
    tabIndex: 4,
    renderContent: `
      <!-- Super Admin Identity Card -->
      <div style="background: white; border-radius: 24px; padding: 26px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03); margin-bottom: 24px; display: flex; align-items: center; gap: 20px;">
        <div style="width: 64px; height: 64px; border-radius: 50%; background: #EDE9FE; display: flex; align-items: center; justify-content: center;">
          <svg width="36" height="36" fill="#7C3AED" viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg>
        </div>
        <div>
          <div style="font-size: 20px; font-weight: 800; color: #0F172A;">Super Administrator</div>
          <div style="font-size: 14px; color: #64748B; margin-top: 2px;">admin@camsik.com</div>
          <div style="display: inline-block; background: #EDE9FE; color: #7C3AED; font-size: 12px; font-weight: 700; padding: 4px 12px; border-radius: 12px; margin-top: 8px;">MASTER ACCESS</div>
        </div>
      </div>

      <!-- System Health Diagnostics -->
      <div style="background: white; border-radius: 24px; padding: 26px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03); margin-bottom: 24px;">
        <div style="font-size: 18px; font-weight: 800; color: #0F172A; margin-bottom: 18px;">Platform Health & Diagnostics</div>
        <div style="display: flex; flex-direction: column; gap: 14px;">
          <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 12px; border-bottom: 1px solid #F1F5F9;">
            <div style="display: flex; align-items: center; gap: 10px;">
              <span style="width: 10px; height: 10px; border-radius: 50%; background: #10B981; display: inline-block;"></span>
              <span style="font-size: 15px; font-weight: 600; color: #334155;">API Cloud Backend</span>
            </div>
            <span style="font-size: 13px; font-weight: 700; color: #166534; background: #DCFCE7; padding: 4px 10px; border-radius: 10px;">Operational (42ms)</span>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 12px; border-bottom: 1px solid #F1F5F9;">
            <div style="display: flex; align-items: center; gap: 10px;">
              <span style="width: 10px; height: 10px; border-radius: 50%; background: #10B981; display: inline-block;"></span>
              <span style="font-size: 15px; font-weight: 600; color: #334155;">Database Cluster</span>
            </div>
            <span style="font-size: 13px; font-weight: 700; color: #166534; background: #DCFCE7; padding: 4px 10px; border-radius: 10px;">Healthy (Atlas Primary)</span>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 12px; border-bottom: 1px solid #F1F5F9;">
            <div style="display: flex; align-items: center; gap: 10px;">
              <span style="width: 10px; height: 10px; border-radius: 50%; background: #10B981; display: inline-block;"></span>
              <span style="font-size: 15px; font-weight: 600; color: #334155;">Fleet Dispatch Engine</span>
            </div>
            <span style="font-size: 13px; font-weight: 700; color: #166534; background: #DCFCE7; padding: 4px 10px; border-radius: 10px;">Active & Syncing</span>
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <span style="font-size: 15px; font-weight: 600; color: #334155;">App Version & Build</span>
            <span style="font-size: 13px; font-weight: 700; color: #475569; background: #F1F5F9; padding: 4px 10px; border-radius: 10px;">v1.0.3 (Build 4)</span>
          </div>
        </div>
      </div>

      <!-- Security Controls -->
      <div style="background: white; border-radius: 24px; padding: 26px; border: 1px solid #E2E8F0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
        <div style="font-size: 18px; font-weight: 800; color: #0F172A; margin-bottom: 18px;">Security & Session Management</div>
        <div style="display: flex; flex-direction: column; gap: 12px;">
          <div style="padding: 14px 18px; border-radius: 16px; background: #F8FAFC; border: 1px solid #E2E8F0; display: flex; justify-content: space-between; align-items: center;">
            <span style="font-size: 15px; font-weight: 600; color: #334155;">Audit Logs & System Activity</span>
            <span style="color: #7C3AED; font-weight: 700; font-size: 14px;">View →</span>
          </div>
          <div style="padding: 14px 18px; border-radius: 16px; background: #F8FAFC; border: 1px solid #E2E8F0; display: flex; justify-content: space-between; align-items: center;">
            <span style="font-size: 15px; font-weight: 600; color: #334155;">Push Notifications Gateway</span>
            <span style="color: #10B981; font-weight: 700; font-size: 14px;">Enabled</span>
          </div>
          <div style="padding: 14px 18px; border-radius: 16px; background: #FEE2E2; border: 1px solid #FECACA; display: flex; justify-content: space-between; align-items: center; margin-top: 6px;">
            <span style="font-size: 15px; font-weight: 700; color: #EF4444;">Log Out Super Admin</span>
            <span style="color: #EF4444; font-weight: 700; font-size: 14px;">Exit Session</span>
          </div>
        </div>
      </div>
    `
  },
  {
    id: '06_admin_login',
    title: 'Secure Admin Gateway',
    isLogin: true,
    renderContent: `
      <div style="min-height: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center; padding: 20px;">
        <div style="width: 90px; height: 90px; border-radius: 50%; background: rgba(124,58,237,0.2); border: 2px solid rgba(124,58,237,0.4); display: flex; align-items: center; justify-content: center; margin-bottom: 24px;">
          <svg width="48" height="48" fill="#C4B5FD" viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg>
        </div>
        <div style="font-size: 34px; font-weight: 900; letter-spacing: 2px; color: white; margin-bottom: 8px;">CAMSIK ADMIN</div>
        <div style="font-size: 16px; color: #94A3B8; margin-bottom: 40px;">Central Command & Control Center</div>

        <div style="width: 100%; max-width: 480px; background: white; border-radius: 28px; padding: 36px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);">
          <div style="font-size: 22px; font-weight: 800; color: #0F172A; margin-bottom: 6px;">Sign In to Admin Panel</div>
          <div style="font-size: 14px; color: #64748B; margin-bottom: 26px;">Enter your master administrator credentials</div>

          <div style="margin-bottom: 20px;">
            <div style="font-size: 13px; font-weight: 700; color: #475569; margin-bottom: 8px;">ADMINISTRATOR EMAIL</div>
            <div style="background: #F8FAFC; border: 1.5px solid #CBD5E1; border-radius: 14px; padding: 14px 18px; font-size: 16px; color: #0F172A; font-weight: 500;">
              admin@camsik.com
            </div>
          </div>

          <div style="margin-bottom: 28px;">
            <div style="font-size: 13px; font-weight: 700; color: #475569; margin-bottom: 8px;">MASTER PASSWORD</div>
            <div style="background: #F8FAFC; border: 1.5px solid #CBD5E1; border-radius: 14px; padding: 14px 18px; font-size: 16px; color: #0F172A; display: flex; justify-content: space-between; align-items: center;">
              <span>••••••••••••</span>
              <svg width="20" height="20" fill="#94A3B8" viewBox="0 0 24 24"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
            </div>
          </div>

          <div style="background: linear-gradient(135deg, #7C3AED 0%, #6D28D9 100%); color: white; border-radius: 16px; padding: 16px; text-align: center; font-size: 17px; font-weight: 700; box-shadow: 0 8px 20px rgba(124,58,237,0.35);">
            Sign In to Command Center →
          </div>
        </div>

        <div style="margin-top: 36px; text-align: center; font-size: 13px; color: #64748B; max-width: 360px; line-height: 1.6;">
          🔒 Strictly authorized for Camsik Operations Team. All access attempts are cryptographically verified and logged.
        </div>
      </div>
    `
  }
];

function generateHtml(screen) {
  const isLogin = screen.isLogin;

  const navItems = [
    { label: 'Overview', icon: '<path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/>' },
    { label: 'Orders', icon: '<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>' },
    { label: 'Partners', icon: '<path d="M20 4H4v2h16V4zm1 10v-2l-1-5H4l-1 5v2h1v6h10v-6h4v6h2v-6h1zm-9 4H6v-4h6v4z"/>' },
    { label: 'Fleet', icon: '<path d="M15.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM5 12c-2.8 0-5 2.2-5 5s2.2 5 5 5 5-2.2 5-5-2.2-5-5-5zm0 8.5c-1.9 0-3.5-1.6-3.5-3.5s1.6-3.5 3.5-3.5 3.5 1.6 3.5 3.5-1.6 3.5-3.5 3.5zm14-8.5c-2.8 0-5 2.2-5 5s2.2 5 5 5 5-2.2 5-5-2.2-5-5-5zm0 8.5c-1.9 0-3.5-1.6-3.5-3.5s1.6-3.5 3.5-3.5 3.5 1.6 3.5 3.5-1.6 3.5-3.5 3.5zM10.8 10.5l2.4-4.5 1.8 1.8V12h2V7.4l-2.6-2.6c-.4-.4-1-.4-1.4 0l-3.2 6H5v2h4.5l1.3-2.3z"/>' },
    { label: 'System', icon: '<path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>' }
  ];

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      -webkit-font-smoothing: antialiased;
    }
    body {
      width: 540px;
      height: 1200px;
      background: ${isLogin ? '#0F172A' : '#F1F5F9'};
      display: flex;
      flex-direction: column;
      overflow: hidden;
      position: relative;
    }
    .status-bar {
      height: 48px;
      padding: 0 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: ${isLogin ? '#0F172A' : '#0F172A'};
      color: white;
      font-size: 15px;
      font-weight: 600;
      letter-spacing: 0.3px;
      flex-shrink: 0;
    }
    .app-bar {
      height: 72px;
      background: #0F172A;
      color: white;
      padding: 0 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid rgba(255,255,255,0.08);
      flex-shrink: 0;
    }
    .app-bar-title {
      font-size: 20px;
      font-weight: 800;
      letter-spacing: 0.2px;
    }
    .app-bar-sub {
      font-size: 13px;
      color: #94A3B8;
      margin-top: 3px;
    }
    .content-area {
      flex: 1;
      padding: 24px;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
    }
    .bottom-nav {
      height: 84px;
      background: white;
      border-top: 1px solid #E2E8F0;
      display: flex;
      align-items: center;
      justify-content: space-around;
      padding: 0 10px;
      flex-shrink: 0;
      box-shadow: 0 -4px 16px rgba(0,0,0,0.03);
    }
    .nav-tab {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 4px;
      cursor: pointer;
      position: relative;
    }
    .nav-pill {
      width: 56px;
      height: 32px;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .nav-tab.active .nav-pill {
      background: #EDE9FE;
    }
    .nav-tab svg {
      width: 22px;
      height: 22px;
    }
    .nav-tab.active svg {
      fill: #7C3AED;
    }
    .nav-tab:not(.active) svg {
      fill: #64748B;
    }
    .nav-label {
      font-size: 12px;
      font-weight: 600;
    }
    .nav-tab.active .nav-label {
      color: #7C3AED;
      font-weight: 700;
    }
    .nav-tab:not(.active) .nav-label {
      color: #64748B;
    }
  </style>
</head>
<body>
  <!-- Status Bar -->
  <div class="status-bar">
    <span>09:41</span>
    <div style="display: flex; gap: 8px; align-items: center;">
      <svg width="18" height="18" fill="white" viewBox="0 0 24 24"><path d="M12 3c-4.97 0-9 4.03-9 9 0 2.12.74 4.07 1.97 5.61L4.35 18.25A10.93 10.93 0 0 1 1 12C1 5.92 5.92 1 12 1s11 4.92 11 11c0 2.28-.7 4.39-1.9 6.15l-.62-.62A9.957 9.957 0 0 0 21 12c0-4.97-4.03-9-9-9zm0 4a5 5 0 0 0-5 5c0 1.25.46 2.39 1.22 3.28l.71-.71A3.985 3.985 0 0 1 8 12c0-2.21 1.79-4 4-4s4 1.79 4 4c0 1.05-.41 2.01-1.07 2.72l.71.71A4.97 4.97 0 0 0 17 12a5 5 0 0 0-5-5zm0 4a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/></svg>
      <svg width="18" height="18" fill="white" viewBox="0 0 24 24"><path d="M12 4C7.31 4 3.07 5.9 0 8.98L12 21 24 8.98A16.88 16.88 0 0 0 12 4z"/></svg>
      <svg width="22" height="22" fill="white" viewBox="0 0 24 24"><path d="M15.67 4H14V2h-4v2H8.33C7.6 4 7 4.6 7 5.33v15.33C7 21.4 7.6 22 8.33 22h7.33c.74 0 1.34-.6 1.34-1.33V5.33C17 4.6 16.4 4 15.67 4z"/></svg>
    </div>
  </div>

  ${!isLogin ? `
  <!-- App Bar -->
  <div class="app-bar">
    <div>
      <div class="app-bar-title">${screen.title}</div>
      <div class="app-bar-sub">Super Administrator</div>
    </div>
    <div style="width: 38px; height: 38px; border-radius: 50%; background: rgba(255,255,255,0.1); display: flex; align-items: center; justify-content: center;">
      <svg width="20" height="20" fill="white" viewBox="0 0 24 24"><path d="M17.65 6.35A7.958 7.958 0 0 0 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08A5.99 5.99 0 0 1 12 18c-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/></svg>
    </div>
  </div>
  ` : ''}

  <!-- Content -->
  <div class="content-area">
    ${screen.renderContent}
  </div>

  ${!isLogin ? `
  <!-- Bottom Navigation -->
  <div class="bottom-nav">
    ${navItems.map((item, idx) => `
      <div class="nav-tab ${idx === screen.tabIndex ? 'active' : ''}">
        <div class="nav-pill">
          <svg viewBox="0 0 24 24">${item.icon}</svg>
        </div>
        <span class="nav-label">${item.label}</span>
      </div>
    `).join('')}
  </div>
  ` : ''}
</body>
</html>`;
}

async function run() {
  const tempDir = path.resolve(__dirname, 'scratch_screenshots');
  if (!fs.existsSync(tempDir)) {
    fs.mkdirSync(tempDir, { recursive: true });
  }

  for (const screen of screens) {
    const htmlContent = generateHtml(screen);
    const htmlPath = path.join(tempDir, `${screen.id}.html`);
    const pngPath = path.join(outputDir, `${screen.id}.png`);

    fs.writeFileSync(htmlPath, htmlContent, 'utf8');

    // Run Chrome headless to render 1080x2400 (scale factor 2 for 540x1200)
    const cmd = `"${chromePath}" --headless --screenshot="${pngPath}" --window-size=540,1200 --device-scale-factor=2 --hide-scrollbars "file:///${htmlPath.replace(/\\\\/g, '/')}"`;
    console.log(`Generating screenshot: ${screen.id}...`);
    execSync(cmd);
    console.log(`Saved: ${pngPath}`);
  }

  console.log('All compliant screenshots successfully generated!');
}

run().catch(console.error);
