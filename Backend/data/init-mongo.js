// MongoDB initialization script
// This script runs when the MongoDB container starts for the first time

// Switch to the eduverse database
db = db.getSiblingDB('eduverse');

// Create collections if they don't exist
db.createCollection('users');
db.createCollection('courses');
db.createCollection('lectures');
db.createCollection('assignments');
db.createCollection('submissions');
db.createCollection('enrollments');
db.createCollection('payments');

// Create indexes for better performance
db.users.createIndex({ "email": 1 }, { unique: true });
db.courses.createIndex({ "title": 1 });
db.lectures.createIndex({ "courseId": 1 });
db.assignments.createIndex({ "courseId": 1 });
db.submissions.createIndex({ "assignmentId": 1 });
db.submissions.createIndex({ "studentId": 1 });
db.enrollments.createIndex({ "studentId": 1, "courseId": 1 }, { unique: true });
db.payments.createIndex({ "userId": 1 });

print('MongoDB initialization completed successfully!'); 