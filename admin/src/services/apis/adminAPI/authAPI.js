import axios from "~/services/axios";

const authAPI = {
  loginRequest: async (data) => {
      const res = await axios.post("/auth/sign-in", data);
      return res.data;
  },
}

export default authAPI;
