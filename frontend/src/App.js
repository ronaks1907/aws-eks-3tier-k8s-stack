import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";
import { useContext } from "react";
import { AuthContext } from "./components/Auth/AuthContext";
import LoginPage from "./components/pages/LoginPage";
import RegisterPage from "./components/pages/RegisterPage";
import UserListPage from "./components/pages/UserListPage";

function App() {
  const { isAuthenticated } = useContext(AuthContext);

  return (
    <Router>
      <Routes>
        <Route
          path="/"
          element={<Navigate to={isAuthenticated ? "/users" : "/login"} />}
        />
        <Route
          path="/login"
          element={isAuthenticated ? <Navigate to="/users" /> : <LoginPage />}
        />
        <Route
          path="/register"
          element={
            isAuthenticated ? <Navigate to="/users" /> : <RegisterPage />
          }
        />
        <Route
          path="/users"
          element={
            isAuthenticated ? <UserListPage /> : <Navigate to="/login" />
          }
        />
      </Routes>
    </Router>
  );
}

export default App;
