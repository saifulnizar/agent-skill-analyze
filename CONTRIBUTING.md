# Contributing to Agent Skill Analyze

Thank you for your interest in improving **Agent Skill Analyze**! We welcome contributions to enhance architectural references, task decomposition rules, implementation idiom catalogs, and overall pipeline accuracy.

---

## 🛠 Adding or Modifying a Skill

Every skill in this repository resides in the `skills/<skill_name>/` directory and must adhere to the following conventions:

1. **`SKILL.md` (Mandatory)**:
   - Must contain a valid YAML Frontmatter at the top:
     ```yaml
     ---
     name: <skill-name>
     description: <Clear, actionable description of when the agent should invoke this skill>
     ---
     ```
   - Must define step-by-step instructions, inputs, expected outputs, and formatting constraints.

2. **Templates & Rules**:
   - `template.md`: Golden output skeleton for the skill.
   - `references/` or `rules/`: Concrete architectural guides, math equations, language idioms, and domain rules to keep the agent grounded and prevent hallucinations.

---

## 🧪 Testing Your Changes Locally

1. Test the installation script:
   ```bash
   bash install-skills.sh
   ```
2. Verify that the skills are successfully installed/linked to `~/.gemini/config/skills/` and `~/.cursor/skills/`.
3. Run test analysis using sample PRDs in `examples/`:
   ```bash
   /arch examples/sample-prd-systems.md --lang=indo
   /plan
   /spec T-01
   ```

---

## 📋 Pull Request Guidelines

- Ensure frontmatter YAML syntax is clean and valid.
- Keep references and rules pragmatic, defensible, and grounded in industry standards (RFCs, seminal CS literature).
- Document any new CLI flags or commands in [README.md](file:///Users/rizkisaifulnizar/Documents/my_project/agent-skill-analyze/README.md).
