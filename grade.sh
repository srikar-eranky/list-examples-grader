CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission 2> git-output.txt
echo 'Finished cloning'

cp student-submission/*.java grading-area
cp *.java grading-area
cp -r lib grading-area

cd grading-area

if ! [[ -f ListExamples.java ]]
then
    echo "file was not found"
    exit 1
fi

javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java 2> compile-error.txt

EXITCODE=$?
if [[ $EXITCODE -ne 0 ]]
then
    echo "tester failed to compile"
    echo "Score 0"
    exit
fi

java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > junit-output.txt
if grep -F 'Failures' junit-output.txt
then
    tail -n 2 junit-output.txt | head -n 1 > output.txt
    TOTAL_TESTS=$(cut -f 3 -d' ' output.txt | tr -d ',')
    FAILURES=$(cut -f 6 -d' ' output.txt)

    NUMERATOR=$(( $TOTAL_TESTS - $FAILURES ))
    SCORE=$(( $NUMERATOR / $TOTAL_TESTS ))
    echo "Your score was" $SCORE
else
    echo "You scored 100%"
fi

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests