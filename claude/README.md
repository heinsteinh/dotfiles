# Claude AI Agent Definitions

This directory contains specialized AI agent definitions for optimizing development and operations workflows with Claude AI.

## 📁 Contents

- `agents.json` - Comprehensive agent definitions for C++/Qt/CMake development, Linux operations, and container/Kubernetes workflows

## 🎯 What Are These Agents?

These are specialized "personas" or expert profiles that you can use with Claude to get targeted, domain-specific assistance. Each agent has:

- **Role**: A specific area of expertise
- **System Prompt**: Detailed context that guides Claude's responses
- **Expertise**: Specific technologies and concepts the agent knows well
- **Use Cases**: When to consult this particular agent

## 🚀 How to Use

### Method 1: Claude Projects (Recommended)

1. Go to [Claude.ai](https://claude.ai)
2. Create a new Project
3. Copy the relevant agent's `system_prompt` from `agents.json`
4. Paste it into the Project's "Custom Instructions" field
5. Name the project after the agent (e.g., "C++ Code Reviewer")

**Benefits**: Persistent context, can upload relevant files, conversations stay organized

### Method 2: Direct Conversation

Simply start your conversation with:

```
Act as [agent role from agents.json]. [Paste the system_prompt here]

Now, help me with: [your specific question]
```

### Method 3: API Integration

If you're using the Claude API, include the system prompt in your API calls:

```python
import anthropic

client = anthropic.Anthropic(api_key="your-api-key")

# Load agent definition
with open('claude/agents.json') as f:
    agents = json.load(f)

agent = agents['agents'][0]  # e.g., cpp_code_reviewer

message = client.messages.create(
    model="claude-sonnet-4-20250514",
    max_tokens=1024,
    system=agent['system_prompt'],
    messages=[
        {"role": "user", "content": "Review this code: ..."}
    ]
)
```

## 📋 Available Agents

### C++ Development (8 agents)
- **cpp_code_reviewer** - Code review, memory safety, best practices
- **qt_specialist** - Qt framework, signals/slots, QML
- **cmake_build_engineer** - CMake configuration, dependencies
- **cpp_debugger** - Debugging crashes, memory issues
- **architecture_advisor** - Software design, patterns
- **testing_engineer** - Unit testing, mocking, TDD
- **performance_optimizer** - Profiling, optimization
- **documentation_writer** - API docs, technical writing

### Linux Operations (8 agents)
- **linux_sysadmin** - Server configuration, systemd
- **dotfile_manager** - Config organization, GNU Stow
- **vim_master** - Vim/Neovim expertise
- **shell_script_expert** - Bash/zsh scripting
- **ssh_remote_specialist** - SSH configuration, tunneling
- **system_troubleshooter** - Diagnosing system issues
- **linux_security_expert** - Security hardening
- **cli_productivity_coach** - Productivity tools, workflows

### Container/Kubernetes (5 agents)
- **docker_specialist** - Dockerfile optimization, Docker Compose
- **kubernetes_architect** - K8s design, orchestration
- **container_devops** - CI/CD pipelines, GitOps
- **container_security** - Container hardening, scanning
- **service_mesh_expert** - Istio, Linkerd, microservices

## 💡 Usage Examples

### Code Review Workflow
```bash
# Before committing C++ changes
# Open Claude with cpp_code_reviewer agent
# Paste your code and ask for review
```

### Setting Up New Server
```bash
# Use linux_sysadmin + linux_security_expert
# Ask for hardening checklist and configuration help
```

### Optimizing Docker Image
```bash
# Use docker_specialist
# Share your Dockerfile and ask for size optimization
```

### Debugging K8s Issues
```bash
# Use kubernetes_architect + system_troubleshooter
# Share kubectl logs/describe output
```

## 🔄 Workflow Integration

The `agents.json` file includes suggested workflow mappings:

**C++ Development:**
- Pre-commit: `cpp_code_reviewer`, `testing_engineer`
- Development: `qt_specialist`, `cmake_build_engineer`
- Debugging: `cpp_debugger`, `testing_engineer`

**Linux Operations:**
- Server setup: `linux_sysadmin`, `linux_security_expert`
- Daily work: `cli_productivity_coach`, `vim_master`
- Troubleshooting: `system_troubleshooter`

**Container Operations:**
- Containerization: `docker_specialist`, `container_security`
- K8s deployment: `kubernetes_architect`, `container_devops`
- CI/CD: `container_devops`, `docker_specialist`

## 🛠️ Customization

Feel free to modify agents for your specific needs:

1. **Add domain-specific knowledge**: Update the `system_prompt` with your company's conventions
2. **Create new agents**: Follow the existing JSON structure
3. **Combine agents**: Use multiple system prompts for complex scenarios

Example custom agent:
```json
{
  "name": "my_company_expert",
  "role": "Company-Specific Expert",
  "system_prompt": "You are an expert in our company's C++ codebase. We use specific patterns: [add your patterns]. Our coding standards: [add standards].",
  "expertise": ["Company codebase", "Internal tools"],
  "use_cases": ["Onboarding", "Code reviews"]
}
```

## 📚 Tips for Best Results

1. **Be specific**: The more context you provide, the better the assistance
2. **Iterate**: Start with one agent, then switch if needed
3. **Combine agents**: For complex problems, consult multiple agents
4. **Share code/configs**: Upload files when using Claude Projects
5. **Use example prompts**: The `agents.json` includes example prompts for each domain

## 🔐 Security Note

- These files contain no secrets or API keys
- Safe to share publicly in your dotfiles repo
- System prompts are just instructions, not credentials

## 📖 References

- [Claude Documentation](https://docs.anthropic.com/)
- [Claude Projects](https://support.anthropic.com/en/articles/9517075-what-are-projects)
- [Prompt Engineering Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)

## 🤝 Contributing

If you create useful agents or improve existing ones:

1. Test them thoroughly
2. Document the use cases
3. Update this README
4. Commit with clear description

## 📝 License

These agent definitions are part of my personal dotfiles. Feel free to use and modify them for your own workflow.

---

**Last Updated**: 2025-10-08
**Compatible with**: Claude Sonnet 4.5, Claude Opus 4
