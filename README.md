# 🔐 Docker Image Hardener

Secure your Docker images by scanning and analyzing them using [Trivy](https://github.com/aquasecurity/trivy). This GitHub Action helps you harden Dockerfiles, identify vulnerabilities, generate SBOM/SARIF reports, and score your image — directly in CI/CD.

---

## 🚀 Features

- 🔍 Trivy scan for vulnerabilities
- 📄 JSON vulnerability report
- 🧾 SBOM generation (CycloneDX format)
- 🧪 SARIF output for GitHub Security tab
- 📊 Scorecard grading (A/B/C/D)
- 📝 GitHub Actions summary report
- 📦 Upload scan artifacts
- 💡 Supports multiple Dockerfiles/images

---

## 🧰 Usage

```yaml
jobs:
  harden:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: 🔒 Run Docker Image Hardener
        uses: developer9508/docker-image-hardener-action@main
        with:
          dockerfile: examples/sample.Dockerfile
          scan: true
          summary: true
          save-json: true
          severity: HIGH,CRITICAL
          sbom: true
          sarif: true
          scorecard: true
