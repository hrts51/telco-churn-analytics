"""
convert_to_html.py
Converts project_documentation.md to a styled, self-contained HTML file.
Run from the project root:
    python report/convert_to_html.py
Output: report/project_documentation.html
"""

from pathlib import Path
import markdown

PROJECT_ROOT = Path(__file__).resolve().parents[1]
INPUT_FILE  = PROJECT_ROOT / "report" / "project_documentation.md"
OUTPUT_FILE = PROJECT_ROOT / "report" / "project_documentation.html"

md_text = INPUT_FILE.read_text(encoding="utf-8")

body_html = markdown.markdown(
    md_text,
    extensions=["tables", "fenced_code", "toc"],
)

HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Telecom Customer Churn Analytics — Project Documentation</title>
  <style>
    /* ── Reset & base ── */
    *, *::before, *::after {{ box-sizing: border-box; margin: 0; padding: 0; }}
    body {{
      font-family: "Segoe UI", Calibri, Arial, sans-serif;
      font-size: 15px;
      line-height: 1.7;
      color: #1a1a2e;
      background: #f7f8fc;
      padding: 0 0 60px 0;
    }}

    /* ── Page wrapper ── */
    .page {{
      max-width: 960px;
      margin: 0 auto;
      background: #ffffff;
      padding: 48px 60px;
      box-shadow: 0 2px 20px rgba(0,0,0,0.08);
    }}

    /* ── Cover band ── */
    .cover {{
      background: linear-gradient(135deg, #1a1a2e 0%, #16213e 60%, #0f3460 100%);
      color: #ffffff;
      padding: 48px 60px 40px 60px;
      margin: 0 0 40px 0;
    }}
    .cover h1 {{
      font-size: 26px;
      font-weight: 700;
      letter-spacing: 0.3px;
      margin-bottom: 10px;
      color: #ffffff;
      border: none;
    }}
    .cover .meta {{
      font-size: 13px;
      color: #a8c8e8;
      line-height: 1.9;
    }}
    .cover .meta span {{ margin-right: 20px; }}

    /* ── Headings ── */
    h1, h2, h3, h4 {{
      font-weight: 700;
      line-height: 1.3;
      margin-top: 36px;
      margin-bottom: 10px;
    }}
    h1 {{ font-size: 24px; color: #0f3460; border-bottom: 3px solid #0f3460; padding-bottom: 8px; }}
    h2 {{ font-size: 19px; color: #16213e; border-bottom: 1px solid #d0d8e8; padding-bottom: 6px; }}
    h3 {{ font-size: 16px; color: #1a1a2e; }}
    h4 {{ font-size: 14px; color: #444; }}

    /* ── Paragraphs and lists ── */
    p  {{ margin: 10px 0; }}
    ul, ol {{ margin: 10px 0 10px 24px; }}
    li {{ margin-bottom: 4px; }}

    /* ── Tables ── */
    table {{
      border-collapse: collapse;
      width: 100%;
      margin: 16px 0;
      font-size: 13.5px;
    }}
    thead tr {{ background: #0f3460; color: #ffffff; }}
    thead th {{ padding: 10px 14px; text-align: left; font-weight: 600; }}
    tbody tr:nth-child(even) {{ background: #f0f4fb; }}
    tbody tr:hover {{ background: #e3eaf7; }}
    td {{ padding: 8px 14px; border-bottom: 1px solid #dde3f0; vertical-align: top; }}

    /* ── Code blocks ── */
    pre {{
      background: #1e2a3a;
      color: #e8f0fe;
      padding: 18px 22px;
      border-radius: 6px;
      overflow-x: auto;
      font-size: 12.5px;
      line-height: 1.6;
      margin: 14px 0;
      border-left: 4px solid #4a90d9;
    }}
    code {{
      font-family: "Cascadia Code", "Consolas", "Courier New", monospace;
    }}
    p code, li code {{
      background: #eef2fb;
      color: #0f3460;
      padding: 2px 6px;
      border-radius: 3px;
      font-size: 13px;
    }}

    /* ── Blockquote ── */
    blockquote {{
      border-left: 4px solid #4a90d9;
      background: #f0f5ff;
      padding: 12px 20px;
      margin: 14px 0;
      color: #333;
      font-style: italic;
    }}

    /* ── Horizontal rule ── */
    hr {{
      border: none;
      border-top: 1px solid #d0d8e8;
      margin: 32px 0;
    }}

    /* ── TOC ── */
    .toc {{
      background: #f0f5ff;
      border: 1px solid #c8d8f0;
      border-radius: 6px;
      padding: 20px 28px;
      margin: 24px 0 32px 0;
      font-size: 13.5px;
    }}
    .toc ul {{ margin: 6px 0 0 16px; }}
    .toc li {{ margin-bottom: 3px; }}
    .toc a {{ color: #0f3460; text-decoration: none; }}
    .toc a:hover {{ text-decoration: underline; }}

    /* ── Print ── */
    @media print {{
      body {{ background: #fff; }}
      .page {{ box-shadow: none; padding: 20px; }}
      .cover {{ -webkit-print-color-adjust: exact; print-color-adjust: exact; }}
      pre {{ white-space: pre-wrap; word-break: break-all; }}
    }}
  </style>
</head>
<body>

  <div class="cover">
    <h1>Telecom Customer Churn Analytics</h1>
    <div class="meta">
      <span>&#128100; Ankit Kumar</span>
      <span>&#128202; IBM Telco Dataset &nbsp;|&nbsp; 7,043 customers</span>
      <span>&#128279; github.com/hrts51/telco-churn-analytics</span>
      <br/>
      <span>&#128736; Python &nbsp;&#183;&nbsp; SQL &nbsp;&#183;&nbsp; Power BI &nbsp;&#183;&nbsp; Git</span>
    </div>
  </div>

  <div class="page">
    {body}
  </div>

</body>
</html>
"""

html_output = HTML_TEMPLATE.format(body=body_html)
OUTPUT_FILE.write_text(html_output, encoding="utf-8")
print(f"Created: {OUTPUT_FILE}")
print(f"Size:    {OUTPUT_FILE.stat().st_size / 1024:.1f} KB")
