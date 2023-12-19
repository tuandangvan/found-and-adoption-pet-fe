import axios from "~/services/axios";

const accountAPI = {
  lock_Unlock: async (data) => {
      const res = await axios.put("/admin/account/status", data);
      return res.data;
  },
}

export default accountAPI;
