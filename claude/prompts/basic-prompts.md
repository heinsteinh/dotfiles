# Basic Prompts for C++ and Kubernetes

## 🔷 C++ Development Prompts

### Code Review
```
Review this C++ code for:
- Memory leaks and unsafe pointer usage
- Const correctness
- Modern C++ best practices (C++17/20)
- Thread safety issues
- Performance concerns

[paste your code here]
```

### Qt Signals and Slots
```
I need to connect a custom signal from my widget to update the UI.
My scenario: [describe your use case]

Help me:
1. Define the signal properly
2. Implement the slot
3. Make the connection in the correct place
4. Handle any threading concerns
```

### CMake Setup
```
I need to set up a CMake project with:
- Qt6 (Widgets and Network modules)
- C++17 standard
- Multiple subdirectories for different libraries
- External dependency: [library name]

Help me structure the CMakeLists.txt files.
```

### Memory Debugging
```
I'm getting a segmentation fault. Here's the stack trace:

[paste stack trace]

And here's the relevant code:

[paste code around the crash]

Help me identify the issue.
```

### Smart Pointers
```
I have this class hierarchy with raw pointers:

[paste your code]

Help me:
1. Convert to appropriate smart pointers (unique_ptr, shared_ptr, weak_ptr)
2. Explain the ownership semantics
3. Ensure proper RAII
```

### Qt Model/View
```
I need to display data in a QTableView. My data structure is:

[describe your data: list of objects, each with properties X, Y, Z]

Help me:
1. Create a custom QAbstractTableModel
2. Implement the required methods
3. Make it editable
4. Add sorting/filtering if possible
```

### Threading in C++
```
I need to run this heavy computation in a background thread and update the UI when done:

[paste your computation code]

Help me implement this safely using:
- Option 1: std::thread with proper synchronization
- Option 2: Qt's QThread
- Include proper mutex/signal handling
```

### Modern C++ Refactoring
```
This code works but uses old C++98 style:

[paste legacy code]

Refactor it to modern C++ (C++17/20) using:
- Auto where appropriate
- Range-based for loops
- Smart pointers
- Structured bindings
- std::optional or std::variant if applicable
```

---

## ☸️ Kubernetes Prompts

### Creating Deployment
```
Create a Kubernetes Deployment manifest for my application:
- Image: [your-registry/your-image:tag]
- Port: [port number]
- Replicas: 3
- Resource limits: 500m CPU, 512Mi memory
- Environment variables: [list them]
- Health checks: readiness and liveness probes
```

### Service and Ingress
```
I have a Deployment named [deployment-name] running on port [port].

Create:
1. A ClusterIP Service to expose it internally
2. An Ingress with:
   - Host: [your-domain.com]
   - Path: /
   - TLS enabled with cert-manager
```

### Debugging Pod Issues
```
My pod is in CrashLoopBackOff state:

Pod name: [pod-name]
Namespace: [namespace]

Here's the output of:
kubectl describe pod [pod-name]
[paste output]

kubectl logs [pod-name]
[paste logs]

Help me diagnose what's wrong.
```

### ConfigMap and Secrets
```
I need to manage configuration for my application:

Configuration data:
- [key1]: [value1]
- [key2]: [value2]

Sensitive data:
- [secret-key]: [description]

Help me:
1. Create a ConfigMap for non-sensitive data
2. Create a Secret for sensitive data
3. Mount them in my Deployment as environment variables
4. Also show how to mount as files
```

### Persistent Storage
```
I need persistent storage for a PostgreSQL database:
- Size: 10Gi
- Access mode: ReadWriteOnce
- Storage class: [your-storage-class or "default"]

Create:
1. PersistentVolumeClaim
2. StatefulSet for PostgreSQL
3. Service for database access
```

### Horizontal Pod Autoscaler
```
Set up autoscaling for my Deployment:
- Deployment name: [name]
- Min replicas: 2
- Max replicas: 10
- Target CPU utilization: 70%
- Target memory utilization: 80%

Create the HPA manifest.
```

### Network Policy
```
I need to restrict network access:

My setup:
- App pod with label: app=[app-name]
- Database pod with label: app=[db-name]
- Namespace: [namespace]

Requirements:
- App should only access database on port 5432
- Database should only accept from app
- Both should allow DNS queries
- Block everything else

Create NetworkPolicy manifests.
```

### Init Containers
```
My application needs initialization before starting:
1. Wait for database to be ready
2. Run database migrations
3. Download configuration from S3

Help me implement init containers in my Deployment.
```

### Rolling Update Strategy
```
Configure a safe rolling update strategy for:
- Zero downtime deployments
- Max 25% pods unavailable during update
- Max 1 extra pod during rollout
- 30 second delay between pod updates

Include the strategy in my Deployment manifest.
```

### Multi-Container Pod
```
I need a pod with:
1. Main app container: [image:tag] on port [port]
2. Sidecar for logging: fluentd
3. Shared volume between containers at /var/log

Create the Pod/Deployment manifest with proper volume mounting.
```

### Namespace and RBAC
```
Create a new namespace for my team with basic RBAC:
- Namespace: [team-name]
- ServiceAccount: [sa-name]
- Role that allows:
  - Full access to Deployments, Services, ConfigMaps
  - Read-only access to Pods (for debugging)
  - No access to Secrets

Provide all manifests: Namespace, ServiceAccount, Role, RoleBinding.
```

### Resource Quotas
```
Set resource limits for namespace [namespace]:
- Max pods: 50
- Max CPU requests: 20 cores
- Max memory requests: 40Gi
- Max persistent volume claims: 10

Create ResourceQuota manifest.
```

---

## 🔀 Combined C++ + K8s Prompts

### Containerizing C++ Qt App
```
I have a C++ Qt application that needs to be containerized:

Build requirements:
- Qt 6.5
- CMake 3.20+
- C++17
- Dependencies: [list them]

Runtime requirements:
- Display forwarding (X11 or Wayland)
- Config file at /etc/myapp/config.yaml

Create:
1. Multi-stage Dockerfile (build + runtime)
2. Docker Compose for local testing
3. K8s Deployment for production
```

### CI/CD for C++ Project
```
Set up CI/CD pipeline for my C++ Qt CMake project:

Pipeline stages:
1. Build with CMake
2. Run unit tests (Google Test)
3. Build Docker image
4. Scan for vulnerabilities
5. Push to registry
6. Deploy to K8s

Provide GitLab CI or GitHub Actions configuration.
```

---

## 💡 Pro Tips

**For C++ prompts:**
- Always include relevant code snippets
- Mention your C++ standard (C++11/14/17/20/23)
- Specify Qt version if applicable
- Include compiler errors if debugging

**For K8s prompts:**
- Mention your K8s version
- Include `kubectl` output for debugging
- Specify if using managed K8s (EKS, GKE, AKS)
- Note any existing infrastructure (Ingress controller, storage class)

**General:**
- Start simple, add complexity as needed
- Ask for explanations, not just code
- Request multiple approaches when appropriate
- Follow up with "Why did you choose X over Y?"
