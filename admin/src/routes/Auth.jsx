import React, { Suspense } from "react";
import { Routes, Route } from "react-router-dom";
import LayoutAdmin from "~/pages/admin/LayoutAdmin/LayoutAdmin";
import Login from "~/pages/Login/Login";

const Auth = () => {
  return (
    <Routes>
      <Route path="*" element={<Suspense></Suspense>} />
      <Route path="/" element={<Login />} />
      <Route path="/admin/*" element={<LayoutAdmin />} />
    </Routes>
  );
};
export default Auth;
