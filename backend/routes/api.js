const express = require('express');
const router = express.Router();
const db = require('../db');

// --- 1. Dashboard Stats ---
router.get('/dashboard-stats', async (req, res) => {
    try {
        const [stats] = await db.query('SELECT * FROM Placement_Analytics_View');
        res.json({ success: true, data: stats });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// --- 2. Generic Query Runner (For DBMS Viva Demonstration) ---
router.post('/run-query', async (req, res) => {
    const { query } = req.body;
    try {
        const startTime = performance.now();
        const [results] = await db.query(query);
        const endTime = performance.now();
        
        res.json({ 
            success: true, 
            data: results, 
            executionTimeMs: (endTime - startTime).toFixed(2) 
        });
    } catch (err) {
        res.status(400).json({ success: false, message: err.message });
    }
});

// --- 3. View Table Data ---
router.get('/table/:tableName', async (req, res) => {
    const tableName = req.params.tableName;
    try {
        // Prevent SQL injection by basic sanitization (only allowing alphanumeric/underscores)
        if (!/^[a-zA-Z0-9_]+$/.test(tableName)) {
            return res.status(400).json({ success: false, message: 'Invalid table name' });
        }
        const [results] = await db.query(`SELECT * FROM ${tableName} LIMIT 100`);
        res.json({ success: true, data: results });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// --- 4. Call Apply_For_Job Procedure ---
router.post('/apply-job', async (req, res) => {
    const { student_id, job_id } = req.body;
    try {
        const [results] = await db.query('CALL Apply_For_Job(?, ?, @p_status); SELECT @p_status AS status;', [student_id, job_id]);
        const statusMsg = results[1][0].status; // Results from the SELECT @p_status
        
        if (statusMsg.startsWith('Error')) {
            return res.status(400).json({ success: false, message: statusMsg });
        }
        res.json({ success: true, message: statusMsg });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// --- 5. Publish Result Procedure ---
router.post('/publish-result', async (req, res) => {
    const { application_id, round_id, score, result_status } = req.body;
    try {
        const [results] = await db.query('CALL Publish_Result(?, ?, ?, ?, @p_msg); SELECT @p_msg AS msg;', [application_id, round_id, score, result_status]);
        const statusMsg = results[1][0].msg;
        
        if (statusMsg.startsWith('Error')) {
            return res.status(400).json({ success: false, message: statusMsg });
        }
        res.json({ success: true, message: statusMsg });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// --- 6. Get Audit Logs ---
router.get('/audit-logs', async (req, res) => {
    try {
        const [logs] = await db.query('SELECT * FROM AUDIT_LOG ORDER BY changed_at DESC LIMIT 50');
        res.json({ success: true, data: logs });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// --- 7. Get Views ---
router.get('/view/:viewName', async (req, res) => {
    const viewName = req.params.viewName;
    try {
        if (!/^[a-zA-Z0-9_]+$/.test(viewName)) {
            return res.status(400).json({ success: false, message: 'Invalid view name' });
        }
        const [results] = await db.query(`SELECT * FROM ${viewName}`);
        res.json({ success: true, data: results });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

module.exports = router;
