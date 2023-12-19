import axiosClient from '~/services/axios';
const reportAPI = {
    getReport: async (status) => {
        const response = await axiosClient.get(`/admin/report/?status=${status}`);
        return response.data;
    },
};

export default reportAPI;
