import React from 'react';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as Yup from 'yup';
import './DonationsForm.css';

const DonationsForm = ({ ngos, onSubmit }) => {
    const schema = Yup.object().shape({
        ngo_slug: Yup.string().required('Selecciona una ONG.'),
        donorName: Yup.string().required('El nombre es obligatorio.'),
        amount: Yup.number().positive('La cantidad debe ser mayor a 0.').required('La cantidad es obligatoria.'),
    });

    const { register, handleSubmit, formState: { errors } } = useForm({
        resolver: yupResolver(schema),
    });

    return (
        <form className="donations-form" onSubmit={handleSubmit(onSubmit)}>
            <label htmlFor="ngo">ONG:</label>
            <select id="ngo" {...register('ngo_slug')}>
                <option value="">Selecciona una ONG</option>
                {ngos.map((ngo) => (
                    <option key={ngo.ngo_slug} value={ngo.ngo_slug}>{ngo.ngo_name}</option>
                ))}
            </select>
            {errors.ngo_slug && <p className="error">{errors.ngo_slug.message}</p>}

            <label htmlFor="donorName">Nombre del Donante:</label>
            <input id="donorName" type="text" {...register('donorName')} />
            {errors.donorName && <p className="error">{errors.donorName.message}</p>}

            <label htmlFor="amount">Cantidad a Donar:</label>
            <input id="amount" type="number" {...register('amount')} />
            {errors.amount && <p className="error">{errors.amount.message}</p>}

            <button type="submit">Donar</button>
        </form>
    );
};

export default DonationsForm;