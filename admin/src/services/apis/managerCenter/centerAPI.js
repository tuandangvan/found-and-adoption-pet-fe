import axiosClient from '~/services/axios';
const userAPI = {
    getAllCenterWithPaging: async () => {
        const response = await axiosClient.get(`/admin/centers`);
        return response.data;
    },
};

export default userAPI;
