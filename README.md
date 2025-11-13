# Cookie Clicker

A modern Cookie Clicker game built with Next.js 16 (frontend) and Go (backend), deployable on Kubernetes.

## Architecture

- **Frontend**: Next.js 16.0.3 with React 19 and Tailwind CSS
- **Backend**: Go HTTP server with health check and API endpoints
- **Deployment**: Kubernetes manifests for container orchestration

## Project Structure

```
cookie-clicker/
├── frontend/          # Next.js frontend application
│   ├── app/           # Next.js app directory
│   ├── public/        # Static assets
│   ├── Dockerfile     # Frontend container image
│   └── package.json   # Node.js dependencies
├── backend/           # Go backend application
│   ├── main.go        # HTTP server implementation
│   ├── go.mod         # Go module definition
│   └── Dockerfile     # Backend container image
└── k8s/               # Kubernetes manifests
    ├── namespace.yaml # Kubernetes namespace
    ├── frontend.yaml  # Frontend deployment and service
    └── backend.yaml   # Backend deployment and service
```

## Local Development

### Frontend

```bash
cd frontend
npm install
npm run dev
```

Visit http://localhost:3000

### Backend

```bash
cd backend
go build -o bin/server .
./bin/server
```

Visit http://localhost:8080/health

## Building Docker Images

### Frontend

```bash
cd frontend
docker build -t cookie-clicker-frontend:latest .
```

### Backend

```bash
cd backend
docker build -t cookie-clicker-backend:latest .
```

## Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured to connect to your cluster
- Docker images built and available to your cluster

### Quick Deploy (Using Script)

For a quick deployment, use the automated deployment script:

```bash
./deploy.sh
```

This script will:
- Build both Docker images
- Load images into minikube (if available)
- Deploy all Kubernetes resources
- Wait for deployments to be ready

To cleanup:

```bash
./cleanup.sh
```

### Manual Deploy to Kubernetes

1. **Create namespace**:
   ```bash
   kubectl apply -f k8s/namespace.yaml
   ```

2. **Deploy backend**:
   ```bash
   kubectl apply -f k8s/backend.yaml
   ```

3. **Deploy frontend**:
   ```bash
   kubectl apply -f k8s/frontend.yaml
   ```

4. **Verify deployments**:
   ```bash
   kubectl get all -n cookie-clicker
   ```

5. **Access the application**:
   ```bash
   # For LoadBalancer type (cloud environments)
   kubectl get service frontend -n cookie-clicker
   
   # For local development (minikube)
   minikube service frontend -n cookie-clicker
   
   # For port forwarding (any environment)
   kubectl port-forward -n cookie-clicker service/frontend 3000:80
   ```

### Scaling

Scale the deployments as needed:

```bash
# Scale frontend
kubectl scale deployment frontend -n cookie-clicker --replicas=3

# Scale backend
kubectl scale deployment backend -n cookie-clicker --replicas=3
```

### Cleanup

Remove all resources:

```bash
kubectl delete namespace cookie-clicker
```

## Features

- **Frontend**: Modern Next.js 16 application with TypeScript and Tailwind CSS
- **Backend**: Lightweight Go HTTP server with health checks
- **Production-ready**: Multi-stage Docker builds for optimized images
- **Kubernetes-ready**: Complete deployment manifests with health probes and resource limits
- **Scalable**: Configured with 2 replicas by default, easily scalable

## API Endpoints

### Backend

- `GET /` - Root endpoint
- `GET /health` - Health check endpoint
- `GET /api` - API info endpoint

## License

See LICENSE file for details.
