import { tool } from "@opencode-ai/plugin/tool"
import { z } from "zod"

// Generic AI patterns to avoid - these are only hardcoded constraints
const ANTI_GENERIC_PATTERNS = [
  "Avoid Inter font unless specifically requested",
  "Avoid Space Grotesk unless specifically requested",
  "Avoid purple gradients on white backgrounds",
  "Avoid generic glassmorphism effects",
  "Avoid cookie-cutter card components",
  "Avoid predictable hero sections",
  "Avoid overused neumorphism",
  "Avoid cliched color schemes"
]

export default tool({
  description: "Create distinctive, production-grade frontend interfaces with high design quality. Provides design thinking guidance and leverages creativity to avoid generic AI aesthetics.",
  args: {
    mode: z.enum(["guidance", "generate"]).describe("Whether to provide design guidance or generate code"),
    requirements: z.string().describe("Frontend requirements and context"),
    framework: z.string().optional().describe("Target framework (React, Vue, HTML/CSS, etc.)"),
    aesthetic: z.string().optional().describe("Preferred aesthetic direction or style"),
    complexity: z.enum(["minimal", "moderate", "elaborate"]).optional().describe("Implementation complexity level")
  },
  async execute(args) {
    const { mode, requirements, framework, aesthetic, complexity } = args

    // Create design thinking prompt
    const designThinkingPrompt = `
You are creating a distinctive, production-grade frontend interface. Apply design thinking first:

## Context Analysis
Requirements: ${requirements}
Framework: ${framework || 'not specified'}
Preferred aesthetic: ${aesthetic || 'open to recommendation'}
Complexity: ${complexity || 'flexible'}

## Design Questions to Consider:
- **Purpose**: What problem does this solve? Who uses it?
- **Tone**: Choose an extreme aesthetic direction (brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, etc.)
- **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?
- **Constraints**: Technical requirements (responsive, accessible, performance)

## Anti-Generic AI Rules:
${ANTI_GENERIC_PATTERNS.map(pattern => `- ${pattern}`).join('\n')}

## Critical Design Direction:
Choose ONE clear aesthetic direction and execute it with precision. Bold maximalism and refined minimalism both work - the key is intentionality, not intensity.

Focus on:
- **Typography**: Choose distinctive, beautiful fonts. Avoid generic choices.
- **Color & Theme**: Commit to a cohesive aesthetic with dominant colors and sharp accents.
- **Motion**: Use high-impact animations and micro-interactions strategically.
- **Spatial Composition**: Unexpected layouts, asymmetry, overlap, diagonal flow.
- **Visual Details**: Create atmosphere with textures, patterns, shadows, borders.
`

    if (mode === 'guidance') {
      return `# Frontend Design Guidance

## Design Thinking Framework
${designThinkingPrompt}

## Next Steps:
1. **Analyze the requirements deeply** - understand purpose, audience, constraints
2. **Choose a bold aesthetic direction** - pick one extreme and commit to it
3. **Define the differentiating factor** - what makes this unforgettable?
4. **Plan the implementation approach** - match complexity to aesthetic vision

## Requirements Analysis:
- **Requirements**: ${requirements}
- **Framework**: ${framework || 'flexible'}
- **Preferred Aesthetic**: ${aesthetic || 'open to recommendation'}
- **Complexity**: ${complexity || 'flexible'}

## Anti-Generic Patterns to Avoid:
${ANTI_GENERIC_PATTERNS.map(pattern => `- ${pattern}`).join('\n')}

Now provide specific aesthetic recommendations, typography choices, color palettes, and implementation strategies based on this framework.

Key principle: Better to execute a simple aesthetic brilliantly than a complex one poorly. Intentionality over intensity.`
    } else {
      return `# Frontend Code Generation

## Design Thinking Framework
${designThinkingPrompt}

## Code Generation Requirements:
- **Framework**: ${framework || 'HTML/CSS'}
- **Complexity**: ${complexity || 'moderate'}
- **Aesthetic**: ${aesthetic || 'determine from requirements'}

## Implementation Guidelines:
1. **Execute the chosen aesthetic with precision** - every detail should reinforce the direction
2. **Create working, functional code** - not just mockups
3. **Include proper structure and organization**
4. **Add thoughtful animations and interactions**
5. **Ensure responsive design** (unless constraints say otherwise)
6. **Use semantic HTML and proper accessibility**

## What to Generate:
- Complete component/page/application
- Styling that matches the aesthetic direction
- Typography that is distinctive and beautiful
- Color system that is cohesive and intentional
- Layout that is unexpected and memorable
- Micro-interactions that delight and surprise

## Requirements Analysis:
- **Requirements**: ${requirements}
- **Framework**: ${framework || 'HTML/CSS'}
- **Preferred Aesthetic**: ${aesthetic || 'determine from requirements'}
- **Complexity**: ${complexity || 'moderate'}

## Anti-Generic Patterns to Avoid:
${ANTI_GENERIC_PATTERNS.map(pattern => `- ${pattern}`).join('\n')}

Now generate the actual frontend code, leveraging your creativity while following the anti-generic patterns and design thinking framework above.`
    }
  }
})
