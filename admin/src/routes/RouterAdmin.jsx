import { Routes, Route } from 'react-router-dom';
import DashboardAdmin from '~/pages/admin/DashboardAdmin/DashboardAdmin';
import LayoutUserAdmin from '~/pages/admin/LayoutUserAdmin/LayoutUserAdmin';
import LayoutCenterAdmin from '~/pages/admin/LayoutCenterAdmin/LayoutCenterAdmin';
import LayoutReportAdmin from '~/pages/admin/LayoutReport/LayoutReportAdmin';

const RouterAdmin = () => {
    return (
        <Routes>
            <Route path="/" element={<DashboardAdmin />} />
            <Route path="/users" element={<LayoutUserAdmin />} />
            <Route path="/centers" element={<LayoutCenterAdmin />} />
            <Route path="/reports" element={<LayoutReportAdmin />} />
            {/* <Route path="/typebeds" element={<LayoutTypeBedAdmin />} />
            <Route path="/facilities" element={<LayoutAmenityAdmin />} />
            <Route path="/facilitycategories" element={<LayoutTypeAmenityAdmin />} /> */}
        </Routes>
    );
};
export default RouterAdmin;
