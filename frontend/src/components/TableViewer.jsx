import React, { useState, useEffect } from 'react';
import axios from 'axios';

const tables = [
  'DEPARTMENT', 'STUDENT', 'COMPANY', 'PLACEMENT_DRIVE', 
  'JOB_ROLE', 'ELIGIBILITY_CRITERIA', 'APPLICATION', 
  'INTERVIEW_ROUND', 'INTERVIEW_RESULT', 'OFFER_LETTER',
  'Eligible_Students_View', 'Company_Statistics_View', 'Interview_Progress_View'
];

const TableViewer = ({ apiBase }) => {
  const [selectedTable, setSelectedTable] = useState('STUDENT');
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      setError(null);
      try {
        let endpoint = tables.includes(selectedTable) && selectedTable.includes('_View') ? `/view/${selectedTable}` : `/table/${selectedTable}`;
        const res = await axios.get(`${apiBase}${endpoint}`);
        setData(res.data.data);
      } catch (err) {
        setError(err.response?.data?.message || err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [apiBase, selectedTable]);

  return (
    <div>
      <h2>Database Tables & Views</h2>
      <div className="flex-row">
        <select value={selectedTable} onChange={(e) => setSelectedTable(e.target.value)} style={{width: '300px'}}>
          {tables.map(t => <option key={t} value={t}>{t}</option>)}
        </select>
        {loading && <span>Loading...</span>}
      </div>

      {error && <div className="error-message">{error}</div>}

      {!loading && !error && data.length > 0 && (
        <div className="table-container animate-fade-in">
          <table>
            <thead>
              <tr>
                {Object.keys(data[0]).map(col => <th key={col}>{col}</th>)}
              </tr>
            </thead>
            <tbody>
              {data.map((row, idx) => (
                <tr key={idx}>
                  {Object.keys(row).map(col => <td key={col}>{String(row[col])}</td>)}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      {!loading && !error && data.length === 0 && <div className="card">No data found in {selectedTable}.</div>}
    </div>
  );
};

export default TableViewer;
