import { useSnackbar } from "notistack";

import Popup from "reactjs-popup";
import LockIcon from "@mui/icons-material/Lock";
import LockOpenIcon from "@mui/icons-material/LockOpen";
import CheckCircleIcon from "@material-ui/icons/CheckCircle";
import VisibilityOffIcon from "@material-ui/icons/VisibilityOff";

import Table from "~/components/Table/Table";
import "./CenterAdmin.scss";
import { Avatar } from "@mui/material";
import accountAPI from "~/services/apis/accountAPI/accountAPI";

const customerTableHead = [
  "STT",
  "Avatar",
  "Name",
  "Email",
  "Phone",
  "Address",
  "Status",
  "Action",
];

const renderHead = (item, index) => <th key={index}>{item}</th>;

const CenterAdmin = (props) => {
  const { enqueueSnackbar } = useSnackbar();
  const handleChangeStatusAccount = (userMail, userStatus) => {
    const status = userStatus === "LOCKED" ? "ACTIVE" : "LOCKED";

    accountAPI
      .lock_Unlock({status: status, email: userMail})
      .then((response) => {
        const updatedUserList = props.data.map((user) => {
          if (user.accountId.email === userMail) {
            return {
              ...user,
              accountId: { ...user.accountId, status: status },
            };
          }
          return user;
        });
        props.setListCenter(updatedUserList);
        enqueueSnackbar(
          `Account ${
            status === "LOCKED" ? "locked" : "unlocked"
          } successfully!`,
          {
            variant: "success",
          }
        );
      })
      .catch((error) => {
        enqueueSnackbar(error.response?.data.message, { variant: "error" });
      });
  };
  const renderBody = (item, index) => (
    <tr key={index}>
      <td>{index + 1}</td>
      <td>
        <Avatar className="avatar" alt="Cindy Baker" src={item.avatar} />
      </td>
      <td>{item.name}</td>
      <td>{item.accountId ? item.accountId.email : null}</td>
      <td>{item.phoneNumber ? item.phoneNumber : "Chưa cập nhật"}</td>
      <td>{item.address}</td>
      <td>
        {item.accountId ? (
          item.accountId.status === "ACTIVE" ? (
            <CheckCircleIcon style={{ color: "green" }} />
          ) : item.accountId.status === "HIDDEN" ? (
            <VisibilityOffIcon style={{ color: "gray" }} />
          ) : item.accountId.status === "LOCKED" ? (
            <LockIcon style={{ color: "red" }} />
          ) : null
        ) : null}
      </td>
      <td>
        <Popup
          trigger={
            item.accountId.status === "LOCKED" ? (
              <LockOpenIcon
                className="icon__btn"
                sx={{ color: "red", cursor: "pointer", fontSize: "18px" }}
              />
            ) : (
              <LockIcon
                className="icon__btn"
                sx={{ color: "red", cursor: "pointer", fontSize: "18px" }}
              />
            )
          }
          position="bottom center"
        >
          <div style={{ backgroundColor: "#CBE2F2", borderRadius: 4 }}>
            <p style={{ marginBottom: 0, padding: "5px", fontSize: "14px" }}>
              {`Are you sure you want to ${
                item.accountId.status === "LOCKED" ? "UNLOCK" : "LOCK"
              } this account?`}
            </p>
            <p
              style={{
                borderRadius: 4,
                background: "#ef5350",
                margin: "0",
                width: "auto",
                paddingLeft: "15px",
                paddingTop: "5px",
                paddingBottom: "5px",
                marginLeft: "75%",
                marginRight: "5px",
                marginBottom: "20px",
                cursor: "pointer",
                color: "white",
              }}
              onClick={() => handleChangeStatusAccount(item.accountId.email, item.accountId.status)}
            >
              Yes
            </p>
          </div>
        </Popup>
      </td>
    </tr>
  );

  return (
    <div className="user__admin">
      <div className="header__customer">
        <h2 className="page-header">Center</h2>
      </div>

      <div className="row">
        <div className="col l-12">
          <div className="card-admin">
            <div className="card__body">
              <Table
                limit="10"
                headData={customerTableHead}
                renderHead={(item, index) => renderHead(item, index)}
                bodyData={props?.data}
                renderBody={(item, index) => renderBody(item, index)}
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CenterAdmin;
