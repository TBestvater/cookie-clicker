#!/bin/bash
# Cleanup script for Cookie Clicker application

set -e

echo "🧹 Cookie Clicker Cleanup Script"
echo "================================="
echo ""

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl first."
    exit 1
fi

echo "⚠️  This will delete the entire cookie-clicker namespace and all resources."
read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "🗑️  Deleting Kubernetes resources..."
kubectl delete namespace cookie-clicker

echo ""
echo "✅ Cleanup completed successfully!"
echo ""
echo "To remove Docker images, run:"
echo "  docker rmi cookie-clicker-frontend:latest"
echo "  docker rmi cookie-clicker-backend:latest"
echo ""
