import React, { useState } from 'react';
import axios from 'axios';

const Procedures = ({ apiBase }) => {
  const [studentId, setStudentId] = useState('CS001');
  const [jobId, setJobId] = useState('1');
  
  const [appId, setAppId] = useState('1');
  const [roundId, setRoundId] = useState('1');
  const [score, setScore] = useState('85.5');
  const [status, setStatus] = useState('Pass');

  const [message, setMessage] = useState(null);
  const [isError, setIsError] = useState(false);

  const applyForJob = async () => {
    try {
      setMessage(null);
      const res = await axios.post(`${apiBase}/apply-job`, { student_id: studentId, job_id: jobId });
      setMessage(res.data.message);
      setIsError(false);
    } catch (err) {
      setMessage(err.response?.data?.message || err.message);
      setIsError(true);
    }
  };

  const publishResult = async () => {
    try {
      setMessage(null);
      const res = await axios.post(`${apiBase}/publish-result`, { 
        application_id: appId, round_id: roundId, score, result_status: status 
      });
      setMessage(res.data.message);
      setIsError(false);
    } catch (err) {
      setMessage(err.response?.data?.message || err.message);
      setIsError(true);
    }
  };

  return (
    <div>
      <h2>Stored Procedures Execution</h2>
      <p className="stat-title" style={{marginBottom: '2rem'}}>Execute transactional business logic directly inside the database.</p>

      {message && (
        <div className={isError ? 'error-message' : 'success-message'}>
          {message}
        </div>
      )}

      <div className="stats-grid">
        <div className="card">
          <h3 style={{marginBottom: '1rem', color: 'var(--primary-color)'}}>Apply_For_Job()</h3>
          <p style={{fontSize: '0.875rem', marginBottom: '1rem', color: 'var(--text-secondary)'}}>
            Checks eligibility, existing applications, and uses transactions to safely insert an application.
          </p>
          <div className="flex-row">
            <input type="text" placeholder="Student ID" value={studentId} onChange={e => setStudentId(e.target.value)} />
            <input type="number" placeholder="Job ID" value={jobId} onChange={e => setJobId(e.target.value)} />
          </div>
          <button className="btn" onClick={applyForJob}>Call Procedure</button>
        </div>

        <div className="card">
          <h3 style={{marginBottom: '1rem', color: 'var(--primary-color)'}}>Publish_Result()</h3>
          <p style={{fontSize: '0.875rem', marginBottom: '1rem', color: 'var(--text-secondary)'}}>
            Updates result and automatically updates application status based on maximum interview rounds.
          </p>
          <div className="flex-row" style={{flexWrap: 'wrap'}}>
            <input type="number" placeholder="App ID" value={appId} onChange={e => setAppId(e.target.value)} style={{width: '100px'}} />
            <input type="number" placeholder="Round ID" value={roundId} onChange={e => setRoundId(e.target.value)} style={{width: '100px'}} />
            <input type="number" placeholder="Score" value={score} onChange={e => setScore(e.target.value)} style={{width: '100px'}} />
            <select value={status} onChange={e => setStatus(e.target.value)}>
              <option value="Pass">Pass</option>
              <option value="Fail">Fail</option>
            </select>
          </div>
          <button className="btn" onClick={publishResult}>Call Procedure</button>
        </div>
      </div>
    </div>
  );
};

export default Procedures;
