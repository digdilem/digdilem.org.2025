rem deploy.bat for digdilem

c:
cd \hugo\digdilem

hugo --cleanDestinationDir

npx wrangler pages deploy c:\hugo\digdilem\public --project-name=digdilem25  --commit-dirty=true

git add .
git commit -am "Updating to reflect development"
git push -f origin main


