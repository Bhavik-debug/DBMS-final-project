import React, { useState, useEffect } from 'react';
import axios from 'axios';

const AuditLogs = ({ apiBase }) => {
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchLogs = async () => {
      try {
        const res = await axios.get(`${apiBase}/audit-logs`);
        setLogs(res.data.data);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchLogs();
  }, [apiBase]);

  return (
    <div>
      <h2>System Audit Logs</h2>
      <p className="stat-title" style={{marginBottom: '2rem'}}>Trigger-generated logs recording critical database operations.</p>
      
      {loading ? <div>Loading...</div> : (
        <div className="table-container animate-fade-in">
          <table>
            <thead>
              <tr>
                <th>Log ID</th>
                <th>Table</th>
                <th>Operation</th>
                <th>Record ID</th>
                <th>Old Value</th>
                <th>New Value</th>
                <th>Changed By</th>
                <th>Timestamp</th>
              </tr>
            </thead>
            <tbody>
              {logs.map(log => (
                <tr key={log.log_id}>
                  <td>{log.log_id}</td>
                  <td><span className={`badge badge-${log.operation === 'DELETE' ? 'danger' : 'primary'}`}>{log.table_name}</span></td>
                  <td>{log.operation}</td>
                  <td>{log.record_id}</td>
                  <td>{log.old_value || '-'}</td>
                  <td>{log.new_value || '-'}</td>
                  <td>{log.changed_by}</td>
                  <td>{new Date(log.changed_at).toLocaleString()}</td>
                </tr>
              ))}
              {logs.length === 0 && (
                <tr><td colSpan="8">No audit logs found. Try modifying some records.</td></tr>
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
};

export default AuditLogs;
