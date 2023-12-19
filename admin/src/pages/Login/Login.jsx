import React, { useState, useEffect } from "react";
import { useDispatch } from "react-redux";
import { useSnackbar } from "notistack";
import { useNavigate } from "react-router-dom";
import userSlice from '~/redux/userSlice';
import "./Login.scss";
import {
  Grid,
  Paper,
  Avatar,
  TextField,
  Button,
  Typography,
  Link,
} from "@material-ui/core";
import LockOutlinedIcon from "@material-ui/icons/LockOutlined";
import FormControlLabel from "@material-ui/core/FormControlLabel";
import Checkbox from "@material-ui/core/Checkbox";
import authAPI from "~/services/apis/adminAPI/authAPI";
const Login = () => {
  const dispatch = useDispatch();
  const paperStyle = {
    padding: 20,
    height: "70vh",
    width: 280,
    margin: "20px auto",
  };
  const avatarStyle = { backgroundColor: "#1bbd7e" };
  const btnstyle = { margin: "8px 0" };
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [messageError, setMessageError] = useState("");
  const { enqueueSnackbar } = useSnackbar();
  const navigate = useNavigate();

  const handleLogin = async (event) => {
    event.preventDefault();
    if (!email) {
      setMessageError("Email is empty!");
      return;
    } else if (!password) {
      setMessageError("Password is empty!");
      return;
    }

    await authAPI.loginRequest({ email, password }).then((res) => {
      try {
        if (res.success && res.data.role === "ADMIN") {
          dispatch(userSlice.actions.signin(res.data));
          navigate("/admin");
        } else {
          if (res.success && res.data.role !== "ADMIN") {
            setMessageError("You not permission!");
          } else {
            setMessageError(res.message);
          }
        }
      } catch (e) {
        setMessageError(e);
      }
    });
  };

  return (
    <Grid>
      <Paper elevation={10} style={paperStyle}>
        <Grid align="center">
          <Avatar style={avatarStyle}>
            <LockOutlinedIcon />
          </Avatar>
          <h2>Sign In</h2>
        </Grid>
        <TextField
          label="Email"
          placeholder="Enter email"
          fullWidth
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <TextField
          label="Password"
          placeholder="Enter password"
          type="password"
          fullWidth
          required
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        {messageError && <h5>{messageError}</h5>}
        <FormControlLabel
          control={<Checkbox name="checkedB" color="primary" />}
          label="Remember me"
        />
        <Button
          type="submit"
          onClick={handleLogin}
          color="primary"
          variant="contained"
          style={btnstyle}
          fullWidth
        >
          Sign in
        </Button>
        <Typography>
          <Link href="#">Forgot password ?</Link>
        </Typography>
      </Paper>
    </Grid>
  );
};

export default Login;
