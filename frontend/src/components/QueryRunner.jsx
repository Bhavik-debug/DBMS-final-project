import React, { useState } from 'react';
import axios from 'axios';
import { Play } from 'lucide-react';

const QueryRunner = ({ apiBase }) => {
  const [query, setQuery] = useState('SELECT * FROM STUDENT LIMIT 10;');
  const [results, setResults] = useState(null);
  const [error, setError] = useState(null);
  const [execTime, setExecTime] = useState(null);

  const runQuery = async () => {
    try {
      setError(null);
      setResults(null);
      const res = await axios.post(`${apiBase}/run-query`, { query });
      setResults(res.data.data);
      setExecTime(res.data.executionTimeMs);
    } catch (err) {
      setError(err.response?.data?.message || err.message);
    }
  };

  const renderTable = () => {
    if (!results) return null;
    if (results.length === 0) return <div className="card">Query executed successfully, but returned 0 rows.</div>;
    
    // Check if it's an array of objects (SELECT) or just an object (INSERT/UPDATE/DELETE)
    if (!Array.isArray(results)) {
        return <div className="card">Query Executed. Affected Rows: {results.affectedRows || 0}</div>;
    }

    const cols = Object.keys(results[0]);
    
    return (
      <div className="table-container">
        <table>
          <thead>
            <tr>
              {cols.map(col => <th key={col}>{col}</th>)}
            </tr>
          </thead>
          <tbody>
            {results.map((row, idx) => (
              <tr key={idx}>
                {cols.map(col => <td key={col}>{String(row[col])}</td>)}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  };

  return (
    <div>
      <h2>Advanced SQL Query Runner</h2>
      <p className="stat-title" style={{marginBottom: '1rem'}}>Execute complex joins, window functions, and analytics here.</p>
      
      <div className="card" style={{marginBottom: '2rem'}}>
        <textarea 
          className="query-editor" 
          value={query} 
          onChange={(e) => setQuery(e.target.value)}
          spellCheck="false"
        ></textarea>
        <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center'}}>
          <button className="btn" onClick={runQuery}>
            <Play size={16} /> Execute Query
          </button>
          {execTime && <span className="badge badge-success">Execution Time: {execTime} ms</span>}
        </div>
      </div>

      {error && <div className="error-message">{error}</div>}
      
      {results && (
        <div className="animate-fade-in">
          <h3 style={{marginBottom: '1rem'}}>Results</h3>
          {renderTable()}
        </div>
      )}
    </div>
  );
};

export default QueryRunner;
