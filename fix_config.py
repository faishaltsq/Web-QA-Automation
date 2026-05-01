with open('/var/jenkins_home/jobs/run-playwright-script/config.xml', 'r') as f:
    content = f.read()

# Fix BUILD_NUMBER placeholder
old = '-e BUILD_NUMBER=\\ playwright-runner:latest'
new = '-e BUILD_NUMBER=${BUILD_NUMBER} playwright-runner:latest'
content = content.replace(old, new)

with open('/var/jenkins_home/jobs/run-playwright-script/config.xml', 'w') as f:
    f.write(content)

import re
m = re.search(r'BUILD_NUMBER[^<\n]+', content)
print('Result:', m.group() if m else 'NOT FOUND')
