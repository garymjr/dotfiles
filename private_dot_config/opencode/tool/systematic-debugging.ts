import { tool } from "@opencode-ai/plugin"

type DebugPhase = "investigation" | "analysis" | "hypothesis" | "implementation"

interface DebugSession {
  id: string
  issue: string
  currentPhase: DebugPhase
  startTime: string
  phases: {
    investigation?: {
      errors: string[]
      reproductionSteps: string[]
      recentChanges: string[]
      evidence: string[]
      completed: boolean
    }
    analysis?: {
      workingExamples: string[]
      differences: string[]
      dependencies: string[]
      completed: boolean
    }
    hypothesis?: {
      statement: string
      test: string
      result: "success" | "failure" | "pending"
      completed: boolean
    }
    implementation?: {
      testCase: string
      fix: string
      verification: string
      completed: boolean
    }
  }
}

// In-memory session storage (in production, this would be persisted)
const sessions = new Map<string, DebugSession>()

function generateSessionId(): string {
  return `debug_${Date.now()}_${Math.random().toString(36).slice(2, 11)}`
}

function validatePhaseProgression(session: DebugSession, targetPhase: DebugPhase): boolean {
  const phases = ["investigation", "analysis", "hypothesis", "implementation"]
  const currentIndex = phases.indexOf(session.currentPhase)
  const targetIndex = phases.indexOf(targetPhase)
  
  if (targetIndex < currentIndex) return false // Can't go backward
  if (targetIndex > currentIndex + 1) return false // Can't skip phases
  
  // Check current phase is completed
  if (session.currentPhase === "investigation" && !session.phases.investigation?.completed) return false
  if (session.currentPhase === "analysis" && !session.phases.analysis?.completed) return false
  if (session.currentPhase === "hypothesis" && !session.phases.hypothesis?.completed) return false
  
  return true
}

function generatePhaseReport(session: DebugSession): string {
  const report = [
    `# Systematic Debugging Session: ${session.id}`,
    `**Issue:** ${session.issue}`,
    `**Current Phase:** ${session.currentPhase}`,
    `**Started:** ${session.startTime}`,
    "",
    "## Phase 1: Root Cause Investigation",
    session.phases.investigation?.completed ? "✅ **COMPLETED**" : "⏳ **IN PROGRESS**",
    "",
    "### Error Messages:",
    ...(session.phases.investigation?.errors.map(e => `- ${e}`) || ["None recorded"]),
    "",
    "### Reproduction Steps:",
    ...(session.phases.investigation?.reproductionSteps.map(s => `- ${s}`) || ["None recorded"]),
    "",
    "### Recent Changes:",
    ...(session.phases.investigation?.recentChanges.map(c => `- ${c}`) || ["None recorded"]),
    "",
    "### Evidence Collected:",
    ...(session.phases.investigation?.evidence.map(e => `- ${e}`) || ["None recorded"]),
    "",
    "## Phase 2: Pattern Analysis",
    session.phases.analysis?.completed ? "✅ **COMPLETED**" : "⏸️ **NOT STARTED**",
    "",
    "### Working Examples:",
    ...(session.phases.analysis?.workingExamples.map(e => `- ${e}`) || ["None recorded"]),
    "",
    "### Key Differences:",
    ...(session.phases.analysis?.differences.map(d => `- ${d}`) || ["None recorded"]),
    "",
    "### Dependencies Identified:",
    ...(session.phases.analysis?.dependencies.map(d => `- ${d}`) || ["None recorded"]),
    "",
    "## Phase 3: Hypothesis Testing",
    session.phases.hypothesis?.completed ? "✅ **COMPLETED**" : "⏸️ **NOT STARTED**",
    "",
    session.phases.hypothesis ? [
      `**Hypothesis:** ${session.phases.hypothesis.statement}`,
      `**Test:** ${session.phases.hypothesis.test}`,
      `**Result:** ${session.phases.hypothesis.result}`
    ].join("\n") : "No hypothesis formed yet.",
    "",
    "## Phase 4: Implementation",
    session.phases.implementation?.completed ? "✅ **COMPLETED**" : "⏸️ **NOT STARTED**",
    "",
    session.phases.implementation ? [
      `**Test Case:** ${session.phases.implementation.testCase}`,
      `**Fix Applied:** ${session.phases.implementation.fix}`,
      `**Verification:** ${session.phases.implementation.verification}`
    ].join("\n") : "No implementation yet.",
    ""
  ].join("\n")
  
  return report
}

function generateInstrumentationTemplate(components: string[]): string {
  const template = [
    "# Multi-Component Instrumentation Template",
    "",
    "Add these logging statements at each component boundary:",
    "",
    ...components.map((component, index) => [
      `## Layer ${index + 1}: ${component}`,
      "```bash",
      `# Layer ${index + 1}: ${component}`,
      `echo "=== ${component} boundary check ==="`,
      `echo "Input data: $INPUT_DATA"`,
      `echo "Environment: $(env | grep -E '^(CONFIG|ENV)' || echo 'No relevant env vars')"`,
      `echo "State: $CURRENT_STATE"`,
      "",
      `# Your ${component} logic here`,
      "",
      `echo "=== ${component} output ==="`,
      `echo "Output data: $OUTPUT_DATA"`,
      `echo "Exit status: $EXIT_STATUS"`,
      "```",
      ""
    ].join("\n")),
    "This will help identify which layer is failing the data flow."
  ].join("\n")
  
  return template
}

export default tool({
  description: "Systematic debugging tool implementing four-phase framework (root cause investigation, pattern analysis, hypothesis testing, implementation)",
  args: {
    action: tool.schema.enum(["start", "phase", "report", "list", "instrument"]).describe("Action to perform"),
    sessionId: tool.schema.string().optional().describe("Session ID (required for phase and report actions)"),
    phase: tool.schema.enum(["investigation", "analysis", "hypothesis", "implementation"]).optional().describe("Target phase"),
    data: tool.schema.string().optional().describe("Phase-specific data in JSON format"),
    issue: tool.schema.string().optional().describe("Issue description (required for start action)"),
    components: tool.schema.string().optional().describe("Component list for instrumentation (comma-separated)")
  },
  async execute({ action, sessionId, phase, data, issue, components }) {
    switch (action) {
      case "start":
        if (!issue) {
          return "Error: Issue description is required when starting a new debugging session"
        }
        
        const newSession: DebugSession = {
          id: generateSessionId(),
          issue,
          currentPhase: "investigation",
          startTime: new Date().toISOString(),
          phases: {}
        }
        
        sessions.set(newSession.id, newSession)
        
        return [
          `🔍 Started systematic debugging session: ${newSession.id}`,
          `📋 Issue: ${issue}`,
          `📍 Current Phase: Root Cause Investigation`,
          "",
          "## Phase 1: Root Cause Investigation",
          "**BEFORE attempting ANY fix:**",
          "1. Read Error Messages Carefully",
          "2. Reproduce Consistently", 
          "3. Check Recent Changes",
          "4. Gather Evidence in Multi-Component Systems",
          "5. Trace Data Flow",
          "",
          `Use: systematic-debugging --action phase --sessionId ${newSession.id} --phase investigation --data '{"errors": ["error1"], "reproductionSteps": ["step1"], "recentChanges": ["change1"], "evidence": ["evidence1"], "completed": true}'`
        ].join("\n")
      
      case "phase":
        if (!sessionId || !phase) {
          return "Error: sessionId and phase are required for phase action"
        }
        
        const session = sessions.get(sessionId)
        if (!session) {
          return `Error: Session ${sessionId} not found`
        }
        
        if (!validatePhaseProgression(session, phase)) {
          return `Error: Cannot progress to ${phase} phase. Current phase: ${session.currentPhase}. Complete current phase first.`
        }
        
        session.currentPhase = phase
        
        if (data) {
          try {
            const phaseData = JSON.parse(data)
            
            if (phase === "investigation") {
              session.phases.investigation = {
                errors: phaseData.errors || [],
                reproductionSteps: phaseData.reproductionSteps || [],
                recentChanges: phaseData.recentChanges || [],
                evidence: phaseData.evidence || [],
                completed: phaseData.completed || false
              }
            } else if (phase === "analysis") {
              session.phases.analysis = {
                workingExamples: phaseData.workingExamples || [],
                differences: phaseData.differences || [],
                dependencies: phaseData.dependencies || [],
                completed: phaseData.completed || false
              }
            } else if (phase === "hypothesis") {
              session.phases.hypothesis = {
                statement: phaseData.statement || "",
                test: phaseData.test || "",
                result: phaseData.result || "pending",
                completed: phaseData.completed || false
              }
            } else if (phase === "implementation") {
              session.phases.implementation = {
                testCase: phaseData.testCase || "",
                fix: phaseData.fix || "",
                verification: phaseData.verification || "",
                completed: phaseData.completed || false
              }
            }
          } catch (e) {
            return `Error parsing phase data: ${e}`
          }
        }
        
        const phaseInstructions = {
          investigation: "Collect error messages, reproduction steps, recent changes, and evidence. Use 'instrument' action for multi-component systems.",
          analysis: "Find working examples, compare against references, identify differences, understand dependencies.",
          hypothesis: "Form single hypothesis, test minimally, verify before continuing.",
          implementation: "Create failing test case, implement single fix, verify fix works."
        }
        
        return [
          `✅ Updated session ${sessionId} to ${phase} phase`,
          `📝 Instructions: ${phaseInstructions[phase]}`,
          "",
          "**Current Status:**",
          `- Investigation: ${session.phases.investigation?.completed ? "✅" : "⏳"}`,
          `- Analysis: ${session.phases.analysis?.completed ? "✅" : "⏸️"}`,
          `- Hypothesis: ${session.phases.hypothesis?.completed ? "✅" : "⏸️"}`,
          `- Implementation: ${session.phases.implementation?.completed ? "✅" : "⏸️"}`
        ].join("\n")
      
      case "report":
        if (!sessionId) {
          return "Error: sessionId is required for report action"
        }
        
        const reportSession = sessions.get(sessionId)
        if (!reportSession) {
          return `Error: Session ${sessionId} not found`
        }
        
        const report = generatePhaseReport(reportSession)
        
        return [
          `📊 Debugging report for session ${sessionId}:`,
          "",
          report
        ].join("\n")
      
      case "list":
        if (sessions.size === 0) {
          return "No debugging sessions found"
        }
        
        const sessionList = Array.from(sessions.values()).map(s => 
          `- **${s.id}**: ${s.issue} (${s.currentPhase})`
        ).join("\n")
        
        return [
          `🔍 Found ${sessions.size} debugging sessions:`,
          "",
          sessionList
        ].join("\n")
      
      case "instrument":
        if (!components) {
          return [
            "Error: Component list is required for instrumentation action",
            "",
            "Example: systematic-debugging --action instrument --components 'workflow,build,signing,deployment'"
          ].join("\n")
        }
        
        const componentList = components.split(",").map(c => c.trim())
        const template = generateInstrumentationTemplate(componentList)
        
        return [
          `🔧 Generated instrumentation template for ${componentList.length} components`,
          "",
          template
        ].join("\n")
      
      default:
        return "Error: Unknown action. Use 'start', 'phase', 'report', 'list', or 'instrument'"
    }
  }
})