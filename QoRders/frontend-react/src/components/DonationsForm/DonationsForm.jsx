import React, { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as Yup from 'yup';
import { FaHandHoldingHeart, FaExclamationCircle, FaUser, FaEuroSign } from 'react-icons/fa';
import './DonationsForm.css';

const DonationsForm = ({ ngos, onSubmit, loading, preselectedNgo }) => {
    const [presetAmount, setPresetAmount] = useState(null);
    
    const schema = Yup.object().shape({
        ngo_slug: Yup.string().required('Por favor, selecciona una ONG para tu donación.'),
        donorName: Yup.string().required('Por favor, introduce tu nombre completo.'),
        amount: Yup.number()
            .typeError('La cantidad debe ser un número válido.')
            .positive('La cantidad debe ser mayor a 0.')
            .required('Por favor, introduce una cantidad para donar.'),
    });

    const { register, handleSubmit, setValue, formState: { errors }, watch } = useForm({
        resolver: yupResolver(schema),
        defaultValues: {
            ngo_slug: preselectedNgo ? preselectedNgo.ngo_slug : '',
            amount: 25
        }
    });
    
    // Observar la cantidad para sincronizar con presets
    const currentAmount = watch('amount');
    
    // Establecer ONG preseleccionada si existe
    useEffect(() => {
        if (preselectedNgo && preselectedNgo.ngo_slug) {
            setValue('ngo_slug', preselectedNgo.ngo_slug);
        }
    }, [preselectedNgo, setValue]);
    
    // Manejar click en botones de cantidad preestablecida
    const handlePresetClick = (amount) => {
        setValue('amount', amount);
        setPresetAmount(amount);
    };
    
    // Actualizar preset seleccionado si cambia manualmente el valor
    useEffect(() => {
        if (currentAmount === 25 || currentAmount === 50 || currentAmount === 100) {
            setPresetAmount(currentAmount);
        } else {
            setPresetAmount(null);
        }
    }, [currentAmount]);

    return (
        <form className="donations-form" onSubmit={handleSubmit(onSubmit)}>
            <div className="form-group">
                <label htmlFor="ngo">Organización</label>
                <select 
                    id="ngo" 
                    className="form-control" 
                    {...register('ngo_slug')}
                    disabled={preselectedNgo ? true : false}
                >
                    <option value="">Selecciona una organización</option>
                    {ngos.map((ngo) => (
                        <option key={ngo.ngo_slug} value={ngo.ngo_slug}>
                            {ngo.ngo_name}
                        </option>
                    ))}
                </select>
                {errors.ngo_slug && (
                    <div className="form-error">
                        <FaExclamationCircle /> {errors.ngo_slug.message}
                    </div>
                )}
            </div>

            <div className="form-group">
                <label htmlFor="donorName">Tu nombre</label>
                <input 
                    id="donorName" 
                    type="text" 
                    className="form-control" 
                    placeholder="Nombre completo" 
                    {...register('donorName')} 
                />
                {errors.donorName && (
                    <div className="form-error">
                        <FaExclamationCircle /> {errors.donorName.message}
                    </div>
                )}
            </div>

            <div className="form-group">
                <label htmlFor="amount">Cantidad a donar</label>
                <div className="donation-preset-buttons">
                    <button 
                        type="button" 
                        className={`preset-button ${presetAmount === 25 ? 'active' : ''}`}
                        onClick={() => handlePresetClick(25)}
                    >
                        €25
                    </button>
                    <button 
                        type="button" 
                        className={`preset-button ${presetAmount === 50 ? 'active' : ''}`}
                        onClick={() => handlePresetClick(50)}
                    >
                        €50
                    </button>
                    <button 
                        type="button" 
                        className={`preset-button ${presetAmount === 100 ? 'active' : ''}`}
                        onClick={() => handlePresetClick(100)}
                    >
                        €100
                    </button>
                </div>
                <div className="donation-amount-wrapper">
                    <span className="amount-currency"></span>
                    <input 
                        id="amount" 
                        type="number" 
                        className="form-control donation-amount" 
                        placeholder="Otra cantidad" 
                        {...register('amount')} 
                    />
                </div>
                {errors.amount && (
                    <div className="form-error">
                        <FaExclamationCircle /> {errors.amount.message}
                    </div>
                )}
            </div>

            <button type="submit" className="submit-button" disabled={loading}>
                {loading ? (
                    <>
                        <span className="loading-indicator"></span>
                        Procesando...
                    </>
                ) : (
                    <>
                        <FaHandHoldingHeart />
                        Realizar Donación
                    </>
                )}
            </button>
        </form>
    );
};

export default DonationsForm;