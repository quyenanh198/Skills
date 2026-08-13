---
name: notebooklm
description: Control NotebookLM (renamed "Gemini Notebook" as of July 2026 — same product, same URL) via browser automation using the Claude Chrome Extension. Use this skill whenever the user wants to interact with any of their notebooks — reading content, pulling summaries or key takeaways, adding sources (URLs, text, files, YouTube links, Word/Sheets/CSV, images), having it research and add sources automatically, generating Studio outputs (audio/video overviews, infographics, slide decks, study guides, flashcards, data tables, briefing docs, mind maps, timelines, FAQs), sharing/collaborating on a notebook, or creating new notebooks. Triggers on any phrase involving NotebookLM or Gemini Notebook — "open NotebookLM", "check my [notebook name] notebook", "pull info from NotebookLM", "ask my notebook about X", "add [source] to NotebookLM", "research X and add it to my notebook", "create an infographic in NotebookLM", "make flashcards from my notebook", "share my notebook with [person]", "generate a slide deck from my notebook", "what does my notebook say about X", or any variation where the goal involves NotebookLM/Gemini Notebook. When in doubt, use this skill — don't try to replicate its functionality manually.
---

# NotebookLM Skill

This skill uses browser automation (Claude in Chrome) to control NotebookLM at https://notebooklm.google.com. Google renamed the product "Gemini Notebook" in July 2026 — it's the same tool, same URL (old links/bookmarks redirect), just newer branding in the UI. Users may call it either name; both mean the same thing.

It handles six main actions: reading/extracting info, adding sources (manually or via automated research), generating Studio outputs, creating new notebooks, and sharing/collaborating.

## Step 0: Always Start Here

Before doing anything else:

1. Call `tabs_context_mcp` to get a valid tab ID — every browser tool requires one
2. Call `computer` (action: `screenshot`) to see the current state of the browser
3. Decide whether to navigate or work from the current page

If not already on NotebookLM, navigate there:
```
navigate(url: "https://notebooklm.google.com", tabId: <tab_id>)
```

Then screenshot again to confirm the page loaded. If you see a Google login screen, stop and tell the user they need to log in first — do not attempt to handle login yourself.

---

## Finding and Opening a Notebook

The homepage shows notebooks as cards in a grid. To open the right one:

1. Screenshot to see what's on the page
2. Use `find` to locate the notebook: `find("<notebook name> card", tabId)`
3. Click it — use the ref from `find` or click from coordinates in the screenshot

If the user didn't specify which notebook to open and there are multiple, screenshot the homepage and ask them which one before proceeding.

---

## Action: Read / Extract Info

Use the notebook's built-in chat to pull information, answer questions, or extract takeaways.

1. Open the notebook
2. Screenshot — the chat input box is at the bottom center of the page
3. `find("chat input", tabId)` or click directly on the input from the screenshot
4. Type the user's question using `computer` (action: `type`)
5. Press Enter: `computer` (action: `key`, text: `Return`)
6. Wait 3–5 seconds, then screenshot to capture the response — for complex questions, the chat may show its intermediate reasoning steps before the final answer; screenshot again after a further wait if the response still looks in-progress
7. Report the answer back in clean, readable form — don't just dump raw chat output

NotebookLM's chat is grounded in the notebook's sources and cites them inline, so the answers are reliable. For broad extraction ("give me all the key points"), ask the question just as you'd phrase it naturally.

---

## Action: Add Sources

Sources can be website URLs, YouTube links, copied text, Google Docs/Sheets/Drive files, Microsoft Word documents, CSV files, images (OCR'd automatically), uploaded local files — or synthesized content you generate on the fly.

1. Open the notebook
2. Screenshot — the Sources panel is the left sidebar
3. Click the **"+ Add source"** button (top of the left panel)
4. A dialog appears with source type options. Handle based on what the user wants to add:

   - **URL / website / YouTube**: Select the link option, paste the URL into the input field using `form_input` or `type`
   - **Copied text**: Select "Copied text", click the text area, type or paste the content
   - **File upload** (PDF, Word, CSV, images, etc.): Use `file_upload` with the file's absolute path and the ref of the file input element — do NOT click the file picker button (it opens a native dialog you can't interact with)
   - **Google Doc / Sheet**: Select the Drive option and follow the Drive picker

5. Confirm / click the upload/add button
6. Wait for processing — NotebookLM shows a spinner while it ingests the source. Use `computer` (action: `wait`, duration: 5), then screenshot to verify it was added successfully

### Synthesizing Content as a Source

Sometimes the user will ask you to *create* content and add it as a source — for example: "turn this conversation into a podcast in NotebookLM" or "research X and add it to my notebook" (for a quick one-off, not a standing research task — see Research & Discover below for that).

In these cases:
1. **Gather or generate the content first** — research it, summarize it, extract it, or write it up based on whatever the user referenced
2. **Add it as "Copied text"** — open the Add Source dialog, select "Copied text", and paste in the synthesized content
3. **Then proceed with whatever action the user asked for** (e.g., generate Audio Overview)

This is a powerful pattern: you're essentially feeding NotebookLM a curated, pre-processed source rather than a raw URL, which often produces better outputs.

---

## Action: Research & Discover Sources

NotebookLM can find and add sources on its own, instead of you (or the user) hunting them down manually. Three distinct tools, don't conflate them:

- **Deep Research**: an agentic mode that searches the web itself and compiles a citation-backed report, adding the sources it used along the way. Use for "research X and build out my notebook" type requests — this is the tool for a real research task, not the manual synthesize-and-paste pattern above.
- **Fast Research**: a lighter-weight version — quickly surfaces relevant web sources for the user to review, without the full report synthesis. Use when the user wants source *candidates* fast, not a finished writeup.
- **Discover sources**: NotebookLM proactively suggests ~10 curated sources related to the notebook's existing content; the user (or you, on their behalf) picks which ones to actually add. Use when a notebook already has some sources and could use more breadth, rather than starting research from scratch.

Workflow:
1. Open the notebook
2. In the Add Source dialog or the Sources panel, `find` the relevant entry point ("Deep Research", "Fast Research", or "Discover" — exact placement varies by rollout, check both the Add Source dialog and the Sources panel toolbar)
3. For Deep Research/Fast Research: type the research query/topic, submit, and wait — these can take a while (comparable to Studio generation), so don't block on it; tell the user it's running and that the sources will appear in the panel when done
4. For Discover: screenshot the suggested source list, and either add all of them or ask the user which ones they want if the choice seems consequential
5. Screenshot to confirm sources landed in the panel before reporting back

---

## Action: Studio Outputs

Studio is NotebookLM's generation feature for creating structured outputs from your notebook's sources. It lives in the right-side panel.

**Available output types:**
- Audio Overview (podcast-style conversation between two AI hosts) — format presets **Deep Dive**, **Brief**, and **Debate**; also supports **Interactive Mode**, where the user can join and talk to the hosts live rather than just listening passively
- Video Overview (narrated slideshow-style video) and **Cinematic Video Overview** (fluid, animated, narrative-led video) — cinematic version may be gated to Google AI Ultra subscribers; if generation fails or the option is missing, tell the user rather than assuming it's a UI-finding bug
- Study Guide (key terms, questions, essay prompts)
- Flashcards and Quizzes — two separate buttons/outputs, not one combined feature
- **Reports** — a single consolidated entry point (not separate buttons for Briefing Doc/Timeline/FAQ/Table of Contents — that's outdated). Opening it shows several **dynamically suggested format templates** based on the notebook's actual sources (e.g. for a history-heavy notebook it might suggest something like an "Industry Analysis Report" or "Historical Overview" — the exact suggestions vary per notebook), plus a free-text option. Pick the suggested format that fits, or describe a custom one.
- Data Tables (structured comparison tables synthesized from the sources — exportable to Google Sheets)
- Infographic (visual summary)
- Slide Deck / Mind Map — slide decks can be exported as **PPTX**, and individual slides can be targeted for re-editing without regenerating the whole deck

**Workflow:**

1. Open the notebook
2. Screenshot — look for the Studio panel on the right side. If you don't see it, look for a "Studio" tab button or panel toggle
3. `find` the output button you need: e.g., `find("Infographic button", tabId)`, `find("Flashcards button", tabId)`, `find("Data Tables button", tabId)`
4. **Open the customization menu first** — each Studio button has a small arrow or chevron on its right side that opens a prompt/customization dialog. Click that (not the main button) to open it before generating. For Audio/Video Overview, this is also where you pick the format preset (Deep Dive/Brief/Debate for audio; standard vs. cinematic for video)
5. **Write a detailed custom prompt** in the customization field. Don't leave it blank or use the default — a specific prompt produces dramatically better output. Tailor it based on what the user is trying to achieve. Examples:
   - For Audio Overview: "Create a dynamic, engaging conversation between two hosts who are genuinely excited about this topic. Focus on the most surprising or counterintuitive insights. Use concrete examples, avoid corporate jargon, and make it accessible to a general audience. Keep the energy high throughout."
   - For Infographic: "Highlight the 5–7 most important concepts with clear visual hierarchy. Emphasize comparisons and relationships between ideas. Use a logical flow from top to bottom."
   - For Reports: if a suggested format template fits, use it as-is or lightly tailor it; otherwise describe the format directly, e.g. "Write a briefing-doc style summary focused on [specific angle], written for someone who hasn't read the sources."
   - For Data Tables: "Compare [the specific dimensions the user cares about] across [the specific items] — keep columns limited to what's directly supported by the sources, don't infer missing data."
   - For Flashcards: "Focus on [specific concept area] rather than every minor detail — prioritize terms/ideas someone would actually need to recall."
   - Adapt the prompt based on what the user told you — if they gave specific direction, incorporate it
6. Confirm/submit the custom prompt and click Generate
7. **Do NOT wait for generation** — Studio outputs (especially Audio/Video Overview) take a long time. Once you've clicked Generate and confirmed the generation has started, tell the user it's in progress and that NotebookLM will notify them when it's ready. Then you're done with this step.
8. **For PPTX export**: once a Slide Deck output exists, look for a download/export option (often a menu on the output card) and select PPTX specifically — don't assume the default download is already PPTX.

**Finding newer Studio features:** If a specific output type isn't visible in the Studio panel, scroll down or look for a "+" or "Discover more" section — newer features are sometimes tucked away there before wider rollout.

---

## Action: Create a New Notebook

1. From the NotebookLM homepage, click "New notebook" or the "+" button
2. A new empty notebook opens
3. Set the title: find and click the title field at the top, then type the name
4. Add sources using the workflow above (manual, or Research & Discover for an autonomous start)
5. NotebookLM will auto-generate a summary and notes once sources finish processing

---

## Action: Sharing & Collaboration

Notebooks can be shared with specific people or published with a public link.

1. Open the notebook
2. `find("Share button", tabId)` — typically top-right of the notebook view
3. In the sharing panel:
   - **Invite specific people**: type their email address(es), and choose a permission level — **Viewer** (read and interact with chat/Studio outputs, can't edit) or **Editor** (can add/edit sources and content). Confirm the invite before reporting back that it's done.
   - **Public link**: look for an "Anyone with the link" (or similar) toggle. This makes the notebook viewable by anyone with the URL — **always confirm with the user before enabling this**, since it's a one-way visibility change they may not want to walk back casually. Viewers of a public notebook can ask questions and view Studio outputs but can't edit sources.
4. Screenshot to confirm the change (invite sent, or public toggle in the expected state) before reporting back

Treat enabling public sharing as a meaningful action — don't do it just because a request could plausibly imply it; if there's any ambiguity about whether the user wants "share with someone specific" vs. "make public," ask.

---

## Saving Outputs

When you extract text, pull takeaways, or generate any output the user wants to keep, save it to their workspace folder. Use the `Write` tool to save text outputs as `.md` files. For downloaded files (audio, video, PPTX, etc.), they'll land in the browser's default download folder — let the user know where to find them.

---

## General Tips

- **Screenshot constantly** — NotebookLM/Gemini Notebook is a dynamic SPA. The UI can vary by account, feature rollout, and the recent rebrand. When in doubt, screenshot before acting.
- **Use `find` before clicking** — it returns stable element refs that are more reliable than pixel coordinates
- **Wait for processing** — source ingestion, research, and Studio generation are all async. Don't assume something is done without a confirming screenshot
- **Chat is your best extraction tool** — for pulling info, it's almost always better to ask the notebook a direct question than to try to scrape the sources panel
- **One action at a time** — do each step, confirm it worked via screenshot, then move to the next
- **Gated/newer features may not appear for every account** — Cinematic Video Overview, for instance, may require a paid tier. If a button or feature you expect isn't there, say so rather than assuming you mis-clicked.

---

## Reporting Back

After completing any action:
1. Take a final screenshot (save_to_disk: true) if there's something visual worth showing
2. Give the user a clear summary: what notebook was used, what was done, what the result was
3. If you extracted information, present it cleanly and formatted — not raw chat dumps
4. If you generated a Studio output or started a research task, describe what was created/started and where to find it when ready
