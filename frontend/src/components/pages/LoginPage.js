import { useContext, useState } from "react";
import { useNavigate } from "react-router-dom";
import { AuthContext } from "../Auth/AuthContext";
import { toast, ToastContainer } from "react-toastify";
import axios from "axios";
import "react-toastify/dist/ReactToastify.css";
import "../css/Auth.css";

function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const { login } = useContext(AuthContext);
  const navigate = useNavigate();

  const handleLogin = async () => {
    try {
      const res = await axios.post("http://k8s-appsalbgroup-88de771a7d-987095670.ap-south-1.elb.amazonaws.com/api/auth/login", {
        email,
        password,
      });
      login(res.data.token);
      toast.success("Login successful!", { autoClose: false });
      setTimeout(() => {
        navigate("/users");
      }, 1000);
    } catch (err) {
      toast.error("Login failed. Please check credentials.");
    }
  };

  return (
    <>
      <ToastContainer />
      <div className="auth-container">
        <h2>Login</h2>
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <button onClick={handleLogin}>Login</button>
        <p>
          Don't have an account? <a href="/register">Register</a>
        </p>
      </div>
    </>
  );
}

export default LoginPage;
