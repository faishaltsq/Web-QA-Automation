import jenkins.model.*
import hudson.model.*
import hudson.tasks.*

def jenkins = Jenkins.getInstance()
def jobName = "run-playwright-script"
def job = jenkins.getItem(jobName)

if (job != null) {
    println "Deleting existing job: ${jobName}"
    job.delete()
}

println "Creating new job: ${jobName}"
job = jenkins.createProject(FreeStyleProject.class, jobName)
job.setDescription("Run Playwright automation script in Docker container")

job.addProperty(new ParametersDefinitionProperty([
    new StringParameterDefinition("SCRIPT_PATH", "", "Relative path to spec file in /data/automation"),
    new StringParameterDefinition("BROWSER", "chromium", "Browser to use"),
    new StringParameterDefinition("BASE_URL", "http://nextjs:3000", "Base URL for tests"),
    new StringParameterDefinition("USER_EMAIL", "risa.stagingtest@gmail.com", "HRIS login email"),
    new StringParameterDefinition("USER_PASSWORD", "stgtest123!", "HRIS login password"),
    new StringParameterDefinition("COMPANY_NAME", "PT RISA STAGING", "Company to select after login")
]))

def shellCmd = '''docker run --rm --network webqa_qa-hub-network \
  -v webqa_automation_scripts:/data/automation \
  -v webqa_reports_data:/data/reports \
  -e SCRIPT_PATH=${SCRIPT_PATH} \
  -e BROWSER=${BROWSER} \
  -e BASE_URL=${BASE_URL} \
  -e BUILD_NUMBER=${BUILD_NUMBER} \
  -e USER_EMAIL=${USER_EMAIL} \
  -e USER_PASSWORD=${USER_PASSWORD} \
  -e COMPANY_NAME=${COMPANY_NAME} \
  webqa-playwright-runner:latest

mkdir -p ${WORKSPACE}/playwright-report
cp -r /data/reports/playwright-html/${BUILD_NUMBER}/* ${WORKSPACE}/playwright-report/ 2>/dev/null || true'''

job.getBuildersList().add(new Shell(shellCmd))

def archiver = new ArtifactArchiver("playwright-report/**")
archiver.setAllowEmptyArchive(true)
job.getPublishersList().add(archiver)

job.save()
println "Job ${jobName} created and configured successfully"