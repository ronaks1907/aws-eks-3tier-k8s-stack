const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/authMiddleware");
const {
  getUser,
  addUser,
  deleteUser,
} = require("../controller/user/usersController");

router.get("/", verifyToken, getUser);
router.post("/", verifyToken, addUser);
router.delete("/:id", verifyToken, deleteUser);

module.exports = router;
