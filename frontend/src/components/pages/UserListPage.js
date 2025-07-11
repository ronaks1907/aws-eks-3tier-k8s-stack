import React, { useState, useEffect } from "react";
import axios from "axios";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { useNavigate } from "react-router-dom";
import "../css/UserForm.css";
import { AuthContext } from "../Auth/AuthContext";
import { useContext } from "react";

const UserListPage = () => {
  const [formData, setFormData] = useState({ name: "", username: "", age: "" });
  const [users, setUsers] = useState([]);
  const navigate = useNavigate();
  const { logout } = useContext(AuthContext);
  const token = localStorage.getItem("token");
  const axiosConfig = {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };

  const fetchUsers = async () => {
    const res = await axios.get("http://k8s-appsalbgroup-88de771a7d-987095670.ap-south-1.elb.amazonaws.com/api/users", axiosConfig);
    setUsers(res.data);
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post(
        "http://k8s-appsalbgroup-88de771a7d-987095670.ap-south-1.elb.amazonaws.com/api/users",
        { ...formData, age: parseInt(formData.age) },
        axiosConfig
      );
      toast.success("User added successfully!");
      setFormData({ name: "", username: "", age: "" });
      fetchUsers();
    } catch (error) {
      console.error(error);
      toast.error("Failed to add user.");
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://k8s-appsalbgroup-88de771a7d-987095670.ap-south-1.elb.amazonaws.com/api/users/${id}`, axiosConfig);
      toast.info("User deleted.");
      fetchUsers();
    } catch (error) {
      console.error(error);
      toast.error("Failed to delete user.");
    }
  };

  const handleLogout = () => {
    logout();
    toast.info("Logged out successfully");
    setTimeout(() => {
      navigate("/login");
    }, 1000);
  };

  return (
    <>
      <h1 className="heading">User Data</h1>
      <div className="form-container">
        <ToastContainer position="top-right" autoClose={3000} />
        <h2>Add User Form</h2>
        <form className="user-form" onSubmit={handleSubmit}>
          <input
            name="name"
            placeholder="Name"
            value={formData.name}
            onChange={handleChange}
            required
          />
          <input
            name="username"
            placeholder="Username"
            value={formData.username}
            onChange={handleChange}
            required
          />
          <input
            name="age"
            type="number"
            placeholder="Age"
            value={formData.age}
            onChange={handleChange}
            required
          />
          <button type="submit">Add User</button>
        </form>

        <div className="user-list">
          <h2>Registered Users</h2>
          {users.length === 0 ? (
            <p>No users yet.</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Username</th>
                  <th>Age</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {users.map((user) => (
                  <tr key={user.id}>
                    <td>{user.name}</td>
                    <td>{user.username}</td>
                    <td>{user.age}</td>
                    <td>
                      <button
                        className="delete-btn"
                        onClick={() => handleDelete(user.id)}
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
        <button className="logout-btn" onClick={handleLogout}>
          Logout
        </button>
      </div>
    </>
  );
};

export default UserListPage;
