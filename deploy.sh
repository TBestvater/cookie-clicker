#!/bin/bash
# Deployment script for Cookie Clicker application

set -e

echo "🍪 Cookie Clicker Kubernetes Deployment Script"
echo "=============================================="
echo ""

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

echo "📦 Building Docker images..."
echo ""

# Build frontend
echo "Building frontend image..."
cd frontend
docker build -t cookie-clicker-frontend:latest .
cd ..
echo "✅ Frontend image built successfully"
echo ""

# Build backend
echo "Building backend image..."
cd backend
docker build -t cookie-clicker-backend:latest .
cd ..
echo "✅ Backend image built successfully"
echo ""

# Load images into minikube if available
if command -v minikube &> /dev/null && minikube status &> /dev/null; then
    echo "🔄 Loading images into minikube..."
    minikube image load cookie-clicker-frontend:latest
    minikube image load cookie-clicker-backend:latest
    echo "✅ Images loaded into minikube"
    echo ""
fi

echo "🚀 Deploying to Kubernetes..."
echo ""

# Apply Kubernetes manifests
kubectl apply -f k8s/namespace.yaml
echo "✅ Namespace created"

kubectl apply -f k8s/backend.yaml
echo "✅ Backend deployed"

kubectl apply -f k8s/frontend.yaml
echo "✅ Frontend deployed"

echo ""
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=120s \
    deployment/backend deployment/frontend -n cookie-clicker

echo ""
echo "✅ Deployment completed successfully!"
echo ""
echo "📊 Current status:"
kubectl get all -n cookie-clicker

echo ""
echo "🌐 Accessing the application:"
echo ""
echo "For minikube:"
echo "  minikube service frontend -n cookie-clicker"
echo ""
echo "For port forwarding:"
echo "  kubectl port-forward -n cookie-clicker service/frontend 3000:80"
echo "  Then visit: http://localhost:3000"
echo ""
echo "For LoadBalancer (cloud environments):"
echo "  kubectl get service frontend -n cookie-clicker"
echo ""
