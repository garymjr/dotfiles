import type { ExtensionFactory } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";

const factory: ExtensionFactory = (pi) => ({
  name: "zai_vision",
  label: "Zai Vision",
  description: "Analyze images using Zai Vision API. Supports multiple analysis types: general description, text extraction, error diagnosis, diagram understanding, data visualization analysis, UI design analysis, and code extraction. Use the appropriate type flag for specific tasks (e.g., 'text' for OCR, 'error' for debugging screenshots, 'code' for extracting code snippets).",
  parameters: Type.Object({
    image_path: Type.String({ description: "Path to the image file to analyze (supports PNG, JPEG, WebP, GIF)" }),
    prompt: Type.String({ description: "Question or instruction for the image analysis" }),
    type: StringEnum(["general", "text", "error", "diagram", "data", "ui", "code"] as const, { description: "Analysis type: general (default), text (OCR), error (debug), diagram (technical), data (charts), ui (design), code (extraction)" }),
  }),

  async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
    const { image_path, prompt, type } = params as {
      image_path: string;
      prompt: string;
      type: "general" | "text" | "error" | "diagram" | "data" | "ui" | "code";
    };

    try {
      // Execute zai-vision-cli with appropriate flags
      const result = await pi.exec("zai-vision-cli", ["-t", type, image_path, prompt], {
        signal,
        timeout: 300000, // 5 minutes (matching CLI default)
      });

      if (result.code !== 0) {
        return {
          content: [{ type: "text", text: `Error analyzing image: ${result.stderr || `Exit code ${result.code}`}` }],
          details: { error: result.stderr || `Exit code ${result.code}`, exitCode: result.code },
        };
      }

      return {
        content: [{ type: "text", text: result.stdout }],
        details: { type, imagePath: image_path },
      };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      return {
        content: [{ type: "text", text: `Failed to analyze image: ${errorMessage}` }],
        details: { error: errorMessage },
      };
    }
  },
});

export default factory;
