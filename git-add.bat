rem deploy.bat for digdilem

c:
cd \code\digdilem

rem hugo --cleanDestinationDir

rem npx wrangler pages deploy c:\code\digdilem\public --project-name=digdilem25  --commit-dirty=true

git add .
git commit -am "Updating to reflect development"
git push -f origin main

rem deploy via cloudflare webhook
https://api.cloudflare.com/client/v4/pages/webhooks/deploy_hooks/0e9dcb22-10a5-4323-946a-821b0245d55b