# AWS EKS 3-Tier Kubernetes Stack

This project demonstrates a complete 3-tier web application stack deployed on **Amazon EKS (Elastic Kubernetes Service)**. It includes:

- A **React** frontend served by **NGINX**
- A **Node.js + Express** backend with **PostgreSQL**
- Kubernetes deployment and service YAMLs to orchestrate everything on AWS EKS

---

## 📦 Project Structure

| Folder          | Description                                       |
|-----------------|---------------------------------------------------|
| `architecture/` | Diagrams illustrating the system architecture     |
| `backend/`      | Node.js backend API with PostgreSQL integration   |
| `frontend/`     | React frontend served using NGINX                 |
| `k8s/`          | Kubernetes manifests for AWS EKS deployment       |
| `README.md`     | Project documentation                             |

---

## 🚀 Features

- 🧩 Modular microservices-based structure
- 🔐 JWT authentication for users
- 🐘 PostgreSQL database support
- ⚙️ Fully containerized using Docker
- ☸️ Deployable on Kubernetes (EKS)
- 📊 Pre-built YAMLs for easy deployment

---

## 🛠️ Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/ronaks1907/aws-eks-3tier-k8s-stack.git
cd aws-eks-3tier-k8s-stack
```

### 2. Setup AWS CLI and EKS Cluster
Ensure AWS CLI and kubectl are configured properly and EKS cluster is running.

```bash
aws eks --region <your-region> update-kubeconfig --name <cluster-name>
```

---

## 🐳 Docker Setup
Build and push your Docker images:

### Backend
```bash
cd backend
docker build -t your-backend-image-name .
docker push your-backend-image-name
```

### Frontend
```bash
cd ../frontend
docker build -t your-frontend-image-name .
docker push your-frontend-image-name
```

## ☸️ Kubernetes Deployment

Apply all manifests under the `k8s/` folder:

```bash
kubectl apply -f k8s/
```

This will create:

- **Deployments**
- **Services**
- **ConfigMaps**
- **PersistentVolumeClaims** (if any)

## 🌐 Accessing the Application

Once deployed, find the LoadBalancer IP:

```bash
kubectl get svc
```
Visit `http://<LOAD_BALANCER_IP>` in your browser to access the application.

---

## 🧪 Development Mode (Local)

### Backend

```bash
cd backend
npm install
npm run dev
```

### Frontend

```bash
cd frontend
npm install
npm start
```
---

## 📷 Architecture Diagram

**Figure 1: High-Level System Architecture**

![High-Level Architecture](./architecture/aws-eks-3tier-architecture.png)

The diagram above illustrates the core components of our platform, including the API Gateway, microservices, and data layer. Communication flows are represented with arrows, and color codes denote deployment zones.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙋‍♂️ Contributing

We welcome contributions! Feel free to open issues or submit pull requests to help improve this project.

---
