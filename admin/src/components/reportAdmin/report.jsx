import { useSnackbar } from "notistack";

import Table1 from "~/components/Table/Table";
import "./ReportAdmin.scss";
import { Avatar } from "@mui/material";
import React, { useState } from "react";
import {
  Dialog,
  DialogContent,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Table,
  CircularProgress,
  IconButton,
  Menu,
  MenuItem,
} from "@material-ui/core";
import Box from "@mui/material/Box";
import Tab from "@mui/material/Tab";
import TabContext from "@mui/lab/TabContext";
import TabList from "@mui/lab/TabList";
import TabPanel from "@mui/lab/TabPanel";

import MoreVertIcon from "@mui/icons-material/MoreVert";
import LockIcon from "@mui/icons-material/Lock";
import DeleteIcon from "@mui/icons-material/Delete";
import CancelIcon from "@mui/icons-material/Cancel";
import postAPI from "~/services/apis/postAPI/postAPI";

const customerTableHead = [
  "STT",
  "Type",
  "Quantity",
  "Status",
  "Created At",
  "Action",
];

const renderHead = (item, index) => <th key={index}>{item}</th>;

const Report = (props) => {
  const { enqueueSnackbar } = useSnackbar();
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);
  const [openPost, setOpenPost] = useState(false);
  const [reporter, setReportter] = useState([]);
  const [anchorEl, setAnchorEl] = useState(null);
  const [postDetail, setPostDetail] = useState(null);
  const [anchorId, setAnchorId] = useState(null);
  const [value, setValue] = useState("1");

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const handleLockPost = (reportId, handleReport) => {
    setLoading(true);
    console.log(loading);
    const data = {
      reportId: reportId,
      handleReport: handleReport,
    };
    postAPI
      .lockPost(data)
      .then((response) => {
        const updatedReportList = props.data.map((report) => {
          if (report.id == reportId) {
            return {
              ...report,
              status: "HANDLED",
            };
          }
          return report;
        });
        props.setListReport(updatedReportList);
        enqueueSnackbar(`Post locked successfully!`, {
          variant: "success",
        });
      })
      .catch((error) => {
        enqueueSnackbar(error.response?.data.message, { variant: "error" });
      });
    setLoading(false);
  };

  const handleClickAction = (event, id) => {
    setAnchorEl(event.currentTarget);
    setAnchorId(id);
  };

  const handleCloseAction = () => {
    setAnchorEl(null);
  };

  const handleGetPostDetail = (postId) => {
    setLoading(true);
    console.log(loading);
    postAPI
      .getPostAD(postId)
      .then((dataRes) => {
        setPostDetail(dataRes.data);
        setLoading(false);
      })
      .catch((error) => {});
  };

  const handleClosePost = () => {
    setOpenPost(false);
  };

  const handleClose = () => {
    setOpen(false);
  };
  const renderBody = (item, index) => (
    <tr key={index}>
      <td>{index + 1}</td>
      <td>
        {item.title}{" "}
        <button
          onClick={() => {
            setOpenPost(true);
            handleGetPostDetail(item.idDestinate);
          }}
        >
          View post
        </button>
      </td>
      <td>
        {item.reporter.length}
        {"\t"}
        <button
          className="btn btn--view-report"
          onClick={() => {
            setReportter(item.reporter);
            setOpen(true);
          }}
        >
          View
        </button>
      </td>
      <td
        style={{
          color:
            item.status === "HANDLED"
              ? "green"
              : item.status == "REJECTED"
              ? "blue"
              : "orange",
          fontWeight: "bold",
        }}
      >
        {item.status}
      </td>
      <td>
        {new Date(item.createdAt).toLocaleString("en-US", {
          timeZone: "Asia/Ho_Chi_Minh",
        })}
      </td>
      <td>
        <IconButton
          onClick={(e) => {
            handleClickAction(e, item._id);
          }}
        >
          <MoreVertIcon />
        </IconButton>
        <Menu
          anchorEl={anchorEl}
          open={Boolean(anchorEl)}
          onClose={handleCloseAction}
        >
          <MenuItem
            onClick={() => {
              handleCloseAction();
              handleLockPost(anchorId, "LOCKED");
            }}
          >
            <LockIcon style={{ color: "#CC9900" }} /> Lock Post
          </MenuItem>
          <MenuItem
            onClick={() => {
              handleCloseAction();
              handleLockPost(anchorId, "DELETE");
            }}
          >
            <DeleteIcon color="error" /> Delete Post
          </MenuItem>
          <MenuItem
            onClick={() => {
              handleCloseAction();
              handleLockPost(anchorId, "REJECT");
            }}
          >
            <CancelIcon style={{ color: "#006600" }} /> Reject reporter
          </MenuItem>
        </Menu>
      </td>
    </tr>
  );

  return (
    <div className="user__admin">
      <div className="header__customer">
        <h2 className="page-header">Manager reports</h2>
      </div>
      <div>
        <TabContext value={value}>
          <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
            <TabList onChange={handleChange} aria-label="lab API tabs example">
              <Tab label="Item One" value="1" />
              <Tab label="Item Two" value="2" />
              <Tab label="Item Three" value="3" />
            </TabList>
          </Box>
          <TabPanel value="1">
            <div className="row">
              <div className="col l-12">
                <div className="card-admin">
                  <div className="card__body">
                    <Table1
                      limit="10"
                      headData={customerTableHead}
                      renderHead={(item, index) => renderHead(item, index)}
                      bodyData={props?.data}
                      renderBody={(item, index) => renderBody(item, index)}
                    />
                  </div>
                  {/* <Dialog open={loading} onClose={loading}>
              <DialogContent>{!loading && <CircularProgress />}</DialogContent>
            </Dialog> */}
                </div>
              </div>
            </div>
            <Dialog open={open} onClose={handleClose}>
              <DialogContent>
                <TableContainer>
                  <Table>
                    <TableHead>
                      <TableRow>
                        <TableCell>STT</TableCell>
                        <TableCell>Name</TableCell>
                        <TableCell>Avatar</TableCell>
                        <TableCell>Reporting reason </TableCell>
                        <TableCell>Reporting date </TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {reporter.map((row, index) => (
                        <TableRow key={index}>
                          <TableCell>{index + 1}</TableCell>
                          <TableCell>
                            {row.userId
                              ? row.userId.lastName
                              : row.centerId.name}
                          </TableCell>
                          <TableCell>
                            <Avatar
                              src={
                                row.userId
                                  ? row.userId.avatar
                                  : row.centerId.avatar
                              }
                            />
                          </TableCell>
                          <TableCell>{row.reason}</TableCell>
                          <TableCell>
                            {new Date(row.dateReport).toLocaleString("en-US", {
                              timeZone: "Asia/Ho_Chi_Minh",
                            })}
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </TableContainer>
              </DialogContent>
            </Dialog>

            <Dialog open={openPost} onClose={handleClosePost}>
              <DialogContent>
                {loading ? (
                  <CircularProgress />
                ) : postDetail ? (
                  <>
                    <Avatar
                      src={
                        postDetail?.userId
                          ? postDetail?.userId?.avatar
                          : postDetail?.centerId?.avatar
                      }
                    />
                    <h2>
                      {postDetail?.userId
                        ? postDetail.userId?.lastName
                        : postDetail?.centerId?.name}
                    </h2>
                    <p>Content: {postDetail?.content}</p>
                    <p>Status: {postDetail?.status}</p>
                    <p>ID post: {postDetail?._id}</p>
                    <p>
                      Date submitted:{" "}
                      {new Date(postDetail?.createdAt).toLocaleString("en-US", {
                        timeZone: "Asia/Ho_Chi_Minh",
                      })}
                    </p>
                    {postDetail?.images.map((image, index) => (
                      <img
                        key={index}
                        src={image}
                        alt="Post"
                        style={{ width: "200px", height: "200px" }}
                      />
                    ))}
                  </>
                ) : (
                  <p>Post not found or deleted!</p>
                )}
              </DialogContent>
            </Dialog>
          </TabPanel>
          <TabPanel value="2">Item Two</TabPanel>
          <TabPanel value="3">Item Three</TabPanel>
        </TabContext>
      </div>
    </div>

    // <div className="user__admin">
    //   <div className="header__customer">
    //     <h2 className="page-header">Manager reports</h2>
    //   </div>

    //   <div className="row">
    //     <div className="col l-12">
    //       <div className="card-admin">
    //         <div className="card__body">
    //           <Table1
    //             limit="10"
    //             headData={customerTableHead}
    //             renderHead={(item, index) => renderHead(item, index)}
    //             bodyData={props?.data}
    //             renderBody={(item, index) => renderBody(item, index)}
    //           />
    //         </div>
    //         {/* <Dialog open={loading} onClose={loading}>
    //           <DialogContent>{!loading && <CircularProgress />}</DialogContent>
    //         </Dialog> */}
    //       </div>
    //     </div>
    //   </div>
    //   <Dialog open={open} onClose={handleClose}>
    //     <DialogContent>
    //       <TableContainer>
    //         <Table>
    //           <TableHead>
    //             <TableRow>
    //               <TableCell>STT</TableCell>
    //               <TableCell>Name</TableCell>
    //               <TableCell>Avatar</TableCell>
    //               <TableCell>Reporting reason </TableCell>
    //               <TableCell>Reporting date </TableCell>
    //             </TableRow>
    //           </TableHead>
    //           <TableBody>
    //             {reporter.map((row, index) => (
    //               <TableRow key={index}>
    //                 <TableCell>{index + 1}</TableCell>
    //                 <TableCell>
    //                   {row.userId ? row.userId.lastName : row.centerId.name}
    //                 </TableCell>
    //                 <TableCell>
    //                   <Avatar
    //                     src={
    //                       row.userId ? row.userId.avatar : row.centerId.avatar
    //                     }
    //                   />
    //                 </TableCell>
    //                 <TableCell>{row.reason}</TableCell>
    //                 <TableCell>
    //                   {new Date(row.dateReport).toLocaleString("en-US", {
    //                     timeZone: "Asia/Ho_Chi_Minh",
    //                   })}
    //                 </TableCell>
    //               </TableRow>
    //             ))}
    //           </TableBody>
    //         </Table>
    //       </TableContainer>
    //     </DialogContent>
    //   </Dialog>

    //   <Dialog open={openPost} onClose={handleClosePost}>
    //     <DialogContent>
    //       {loading ? (
    //         <CircularProgress />
    //       ) : (
    //         postDetail?
    //         <>
    //           <Avatar
    //             src={
    //               postDetail?.userId
    //                 ? postDetail?.userId?.avatar
    //                 : postDetail?.centerId?.avatar
    //             }
    //           />
    //           <h2>
    //             {postDetail?.userId
    //               ? postDetail.userId?.lastName
    //               : postDetail?.centerId?.name}
    //           </h2>
    //           <p>Content: {postDetail?.content}</p>
    //           <p>Status: {postDetail?.status}</p>
    //           <p>ID post: {postDetail?._id}</p>
    //           <p>
    //             Date submitted:{" "}
    //             {new Date(postDetail?.createdAt).toLocaleString("en-US", {
    //               timeZone: "Asia/Ho_Chi_Minh",
    //             })}
    //           </p>
    //           {postDetail?.images.map((image, index) => (
    //             <img
    //               key={index}
    //               src={image}
    //               alt="Post"
    //               style={{ width: "200px", height: "200px" }}
    //             />
    //           ))}
    //         </>:<p>Post not found or deleted!</p>
    //       )}
    //     </DialogContent>
    //   </Dialog>
    // </div>
  );
};

export default Report;
