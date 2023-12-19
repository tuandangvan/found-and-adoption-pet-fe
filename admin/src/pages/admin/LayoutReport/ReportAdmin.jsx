import "./ReportAdmin.scss";
import React, { useState } from "react";
import Box from "@mui/material/Box";
import Tab from "@mui/material/Tab";
import TabContext from "@mui/lab/TabContext";
import TabList from "@mui/lab/TabList";
import TabPanel from "@mui/lab/TabPanel";
import Report from "./report";

const ReportAdmin = (props) => {
  const [value, setValue] = useState("1");

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  return (
    <div className="user__admin">
      <div className="header__customer">
        <h2 className="page-header">Manager reports</h2>
      </div>
      <div>
        <TabContext value={value}>
          <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
            <TabList onChange={handleChange} aria-label="lab API tabs example">
              <Tab label="PENDING" value="1" />
              <Tab label="HANDLED" value="2" />
              <Tab label="REJECTED" value="3" />
            </TabList>
          </Box>
          <TabPanel value="1">
            <Report
              data={props.dataPD}
              setListReportPD={props.setListReportPD}
              listReportHD={props.dataHD}
              setListReportHD={props.setListReportHD}
              listReportRJ={props.dataRJ}
              setListReportRJ={props.setListReportRJ}
            />
          </TabPanel>
          <TabPanel value="2">
            <Report data={props.dataHD} />
          </TabPanel>
          <TabPanel value="3">
            <Report
              data={props.dataRJ}
            />
          </TabPanel>
        </TabContext>
      </div>
    </div>
  );
};

export default ReportAdmin;
