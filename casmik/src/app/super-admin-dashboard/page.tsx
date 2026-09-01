import React from 'react';
import AdminLayout from '@/app/super-admin-dashboard/components/AdminLayout';
import AdminSectionRouter from '@/app/super-admin-dashboard/components/AdminSectionRouter';

export default function SuperAdminDashboardPage() {
  return (
    <AdminLayout>
      <AdminSectionRouter />
    </AdminLayout>
  );
}