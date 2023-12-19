import { useState, useEffect, useContext } from "react";

import UserAdmin from "~/pages/admin/LayoutUserAdmin/UserAdmin";
import LoadingAdmin from "~/components/Admin/LoadingAdmin/LoadingAdmin";
import userAPI from "~/services/apis/managerUser/userAPI";

const LayoutUserAdmin = () => {
  const [listUser, setListUser] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    setIsLoading(true);
    userAPI
      .getAllUserWithPaging()
      .then((dataRes) => {
        setListUser(dataRes.data);
        setIsLoading(false);
      })
      .catch((error) => {});

    // cmsUserAPI
    //     .getAllUserWithPaging()
    //     .then((dataResponse) => {
    //         setListUser(dataResponse.data.content);
    //         setIsLoading(false);
    //     })
    //     .catch((error) => {

    //     });
  }, []);

  return (
    <>
      {isLoading ? (
        <LoadingAdmin />
      ) : (
        <UserAdmin data={listUser} setListUser={setListUser} />
      )}
    </>
  );
};

export default LayoutUserAdmin;
