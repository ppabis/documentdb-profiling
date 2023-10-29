#!/usr/bin/python3
import pymongo, requests, uuid, random, os

"""
This script creates a fake database of students and their answers to a quiz.
There should be so many records that it hopefully generates profiler findings.
"""

MONGO_URL = os.environ.get('MONGO_URL')
CA_FILE = "/usr/local/share/ca-certificates/rds.pem"

## All possible random answers
def load_wordlist_to_list():
    WORDLIST="https://raw.githubusercontent.com/bitcoin/bips/master/bip-0039/english.txt"
    return requests.get(WORDLIST).text.split('\n')

## Let's generate ~5000 student IDs who took the quiz
def generate_student_ids():
    student_ids = set([
        random.randint(10000000, 99999999) for _ in range(5000)
    ])
    return [{
        "student_id": student_id,
        "email": f"{student_id}@example-test-fake-404.edu"
    } for student_id in student_ids]

## Generate 1000 questions
def generate_question_set(wordlist):
    return [{
        "question_id": i,
        "question": f"Question {i}: {random.choice(wordlist)} {random.choice(wordlist)} {random.choice(wordlist)} {random.choice(wordlist)}"
    } for i in range(1, 1001)]

## Create random answers for a student, 1000 questions
def genrenerate_random_answers(student_uuid, wordlist):
    return [{
        "student_id": student_uuid,
        "question_id": i,
        "answer": random.choice(wordlist)
    } for i in range(1, 1001)]

def main():
    wordlist = load_wordlist_to_list()
    students = generate_student_ids()
    mongo = pymongo.MongoClient(f"mongodb://{MONGO_URL}/?tls=true&tlsCAFile={CA_FILE}")
    info = mongo.server_info()
    print(f"Connected to MongoDB version {info['version']}")

    # Clear all the items in the database
    if mongo.get_database("college").get_collection("students") is not None:
        mongo.get_database("college").drop_collection("students")
    if mongo.get_database("college").get_collection("quiz") is not None:
        mongo.get_database("college").drop_collection("quiz")
    if mongo.get_database("college").get_collection("questions") is not None:
        mongo.get_database("college").drop_collection("questions")
    
    print(f"Creating {len(students)} students...")
    students_coll = mongo.get_database("college").create_collection("students")
    students_coll.insert_many(students)
    students_coll.create_index("student_id", unique=True)

    questions = generate_question_set(wordlist)
    print(f"Creating {len(questions)} questions...")
    questions_coll = mongo.get_database("college").create_collection("questions")
    questions_coll.insert_many(questions)

    quiz = mongo.get_database("college").create_collection("quiz")

    print(f"Creating {len(students)} x 1000 answers...")
    for student in students:
        # Get student UUID in Mongo
        student_uuid = students_coll.find_one({"student_id": student["student_id"]})["_id"]
        answers = genrenerate_random_answers(student_uuid, wordlist)
        quiz.insert_many(answers)

    mongo.close()

if __name__ == "__main__":
    main()