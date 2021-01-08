# increment build version
agvtool bump

# get semantic version

PROJECT_PATH="GrainSwift.xcodeproj"
MARKETING_VERSION=""
LINES=$(sed -n '/MARKETING_VERSION/=' "$PROJECT_PATH/project.pbxproj")
for LINE in $LINES; do
  MARKETING_VERSION=$(sed -n "$LINE"p "$PROJECT_PATH"/project.pbxproj)
  MARKETING_VERSION="${MARKETING_VERSION#*= }"
  MARKETING_VERSION="${MARKETING_VERSION%;}"
done

if [ -z "$MARKETING_VERSION" ]; then
  echo "MARKETING_VERSION is empty"
  exit 1
fi

echo "version: $MARKETING_VERSION"


# get build version

PROJECT_PATH="GrainSwift.xcodeproj"
CURRENT_PROJECT_VERSION=""
LINES=$(sed -n '/CURRENT_PROJECT_VERSION/=' "$PROJECT_PATH/project.pbxproj")
for LINE in $LINES; do
  CURRENT_PROJECT_VERSION=$(sed -n "$LINE"p "$PROJECT_PATH"/project.pbxproj)
  CURRENT_PROJECT_VERSION="${CURRENT_PROJECT_VERSION#*= }"
  CURRENT_PROJECT_VERSION="${CURRENT_PROJECT_VERSION%;}"
done

if [ -z "$CURRENT_PROJECT_VERSION" ]; then
  echo "CURRENT_PROJECT_VERSION is empty"
  exit 1
fi

echo "build: $CURRENT_PROJECT_VERSION"


# tag

current_tag="v_${MARKETING_VERSION}_${CURRENT_PROJECT_VERSION}"

echo -e "\n"
echo "--------------------------------------"
echo "git add $PROJECT_PATH/project.pbxproj"
echo "git commit -m \"version ${MARKETING_VERSION} build ${CURRENT_PROJECT_VERSION}\""
echo "--------------------------------------"
echo -e "\n"


read -e -p "Add files and commit? [Y/n] " YN
if [[ $YN == "y" || $YN == "Y" || $YN == "" ]]; then
  echo "committing..."
  git add "$PROJECT_PATH/project.pbxproj"
  git commit -m "version ${MARKETING_VERSION} build ${CURRENT_PROJECT_VERSION}"
else
  exit 0
fi


echo -e "\n"
echo "--------------------------------------"
echo "git tag ${current_tag}"
echo "git push origin ${current_tag}"
echo "git push origin"
echo "--------------------------------------"
echo -e "\n"

read -e -p "Tag and push to origin? [Y/n] " YN
if [[ $YN == "y" || $YN == "Y" || $YN == "" ]]; then
  echo "pushing..."
  git tag ${current_tag}
  git push origin ${current_tag}
  git push origin
else
  exit 0
fi
