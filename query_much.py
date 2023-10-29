#!/usr/bin/python3
import pymongo, requests, uuid, random, os, time

MONGO_URL = os.environ.get('MONGO_URL')
CA_FILE = "/usr/local/share/ca-certificates/rds.pem"

def get_top10_answers_to_question(quiz):
    """
    Get top 10 answers to question 1-random(100, 1000)
    """
    max_question = random.randint(100, 1000)
    results = quiz.aggregate([
        {
            "$match": {
                "question_id": {
                    "$lte": max_question
                }
            }
        },
        {
            "$group": {
                "_id": "$answer",
                "count": {"$sum": 1}
            }
        },
        {
            "$sort": {"count": -1}
        },
        {
            "$limit": 10
        }
    ], allowDiskUse=True)
    for result in results:
        print(result)

def get_emails_students_that_answered_question_with_abcdef_the_most(quiz):
    """
    Get emails of students that answered the most to questions with answers starting
    with a-f
    """
    results = quiz.aggregate([
        {
            "$match": {
                "answer": {
                    "$regex": "^[abcdef]"
                }
            }
        },
        {
            "$group": {
                "_id": "$student_id",
                "count": {"$sum": 1}
            }
        },
        {
            "$sort": {"count": -1}
        },
        {
            "$lookup": {
                "from": "students",
                "localField": "_id",
                "foreignField": "_id",
                "as": "student"
            }
        },
        {
            "$limit": 10
        }
    ], allowDiskUse=True)
    for result in results:
        print(result)

def main():
    mongo = pymongo.MongoClient(f"mongodb://{MONGO_URL}/?tls=true&tlsCAFile={CA_FILE}")
    info = mongo.server_info()
    print(f"Connected to MongoDB version {info['version']}")

    quiz = mongo.get_database("college").get_collection("quiz")
    
    start = time.time()
    get_top10_answers_to_question(quiz)
    end = time.time()
    print(f"Query took {(end - start):.3f} seconds")

    start = time.time()
    get_emails_students_that_answered_question_with_abcdef_the_most(quiz)
    end = time.time()
    print(f"Query took {(end - start):.3f} seconds")


if __name__ == "__main__":
    main()