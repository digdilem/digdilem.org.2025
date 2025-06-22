rem deploy.bat for digdilem

c:
cd \huge\digdilem

hugo --cleanDestinationDir

rem export CLOUDFLARE_API_TOKEN="tvXm8ysXzgmx6i4nBHPST0l4B2mqrN7HPz8p4N_E"

npx wrangler pages deploy c:\hugo\digdilem\public --project-name=digdilem25