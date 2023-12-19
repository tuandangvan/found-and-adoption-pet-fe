import axios from "~/services/axios";

const postAPI = {
  getPostAD: async (postId) => {
      const res = await axios.get(`/admin/post/${postId}`);
      return res.data;
  },
  lockPost: async (data) => {
      const res = await axios.put(`/admin/report/handle`, data);
      return res.data;
  },
}

export default postAPI;
