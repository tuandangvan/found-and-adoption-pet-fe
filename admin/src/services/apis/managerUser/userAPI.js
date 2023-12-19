import axiosClient from '~/services/axios';
const userAPI = {
    getAllUserWithPaging: async () => {
        const response = await axiosClient.get(`/admin/users`);
        return response.data;
    },
};

export default userAPI;
