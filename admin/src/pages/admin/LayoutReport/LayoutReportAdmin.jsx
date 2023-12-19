import { useState, useEffect, useContext } from "react";

import ReportAdmin from "~/pages/admin/LayoutReport/ReportAdmin";
import LoadingAdmin from "~/components/Admin/LoadingAdmin/LoadingAdmin";
import reportAPI from "~/services/apis/reportAPI/centerAPI";

const LayoutReportAdmin = () => {
  const [listReportPD, setListReportPD] = useState([]);
  const [listReportHD, setListReportHD] = useState([]);
  const [listReportRJ, setListReportRJ] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    setIsLoading(true);
    reportAPI
      .getReport("PENDING")
      .then((dataRes) => {
        setListReportPD(dataRes.data);
        setIsLoading(false);
      })
      .catch((error) => {});

      reportAPI
      .getReport("HANDLED")
      .then((dataRes) => {
        setListReportHD(dataRes.data);
        setIsLoading(false);
      })
      .catch((error) => {});

      reportAPI
      .getReport("REJECTED")
      .then((dataRes) => {
        setListReportRJ(dataRes.data);
        setIsLoading(false);
      })
      .catch((error) => {});
  }, []);

  return (
    <>
      {isLoading ? (
        <LoadingAdmin />
      ) : (
        <ReportAdmin
          dataPD={listReportPD}
          setListReportPD={setListReportPD}
          dataHD={listReportHD}
          setListReportHD={setListReportHD}
          dataRJ={listReportRJ}
          setListReportRJ={setListReportRJ}
        />
      )}
    </>
  );
};

export default LayoutReportAdmin;
