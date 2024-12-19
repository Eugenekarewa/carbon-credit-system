// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskManager {
    struct Task {
        uint256 id;
        string description;
        bool isCompleted;
    }

    Task[] public tasks; // Array to store tasks
    uint256 public taskCount = 0;

    // Add a new task
    function addTask(string memory _description) public {
        tasks.push(Task(taskCount, _description, false));
        taskCount++;
    }

    // Mark a task as completed
    function completeTask(uint256 _id) public {
        require(_id < taskCount, "Task does not exist");
        tasks[_id].isCompleted = true;
    }

    // Get a task by ID
    function getTask(uint256 _id) public view returns (uint256, string memory, bool) {
        require(_id < taskCount, "Task does not exist");
        Task memory task = tasks[_id];
        return (task.id, task.description, task.isCompleted);
    }

    // Get all tasks
    function getAllTasks() public view returns (Task[] memory) {
        return tasks;
    }
}
