import { useState, useEffect, useContext } from "react";

import CenterAdmin from "~/pages/admin/LayoutCenterAdmin/CenterAdmin";
import LoadingAdmin from "~/components/Admin/LoadingAdmin/LoadingAdmin";
import centerAPI from "~/services/apis/managerCenter/centerAPI";

const LayoutCenterAdmin = () => {
  const [listCenter, setListCenter] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    setIsLoading(true);
    centerAPI
      .getAllCenterWithPaging()
      .then((dataRes) => {
        setListCenter(dataRes.data);
        setIsLoading(false);
      })
      .catch((error) => {});
  }, []);

  return (
    <>
      {isLoading ? (
        <LoadingAdmin />
      ) : (
        <CenterAdmin data={listCenter} setListCenter={setListCenter} />
      )}
    </>
  );
};

export default LayoutCenterAdmin;
